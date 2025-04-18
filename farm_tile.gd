extends "res://tile.gd"
class_name FarmTile

var wheatParticlePreload = preload("res://WheatHarvestParticle.tscn")
var cornPartilePreload = preload("res://CornHarvestParticle.tscn")
var tileState = ["unfertile", "fertile", "seeded", "growing", "harvestable"]
var cropType = "default" #what kind of crop
var growSpeed:int = 30  #30 there is a 1/growSpeed chance every .5 sec, def = 30
var waterSources = {} #dictionary of all waterSources

@onready var player = $HitBox.player

var currentTextureRegions: Dictionary
var currentHarvestParticle

var wheatTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(0, 32, 16, 16),
	"growing": Rect2(0, 48, 16, 16),
	"harvestable": Rect2(0, 64, 16, 32)
	}
	
var cornTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(16, 32, 16, 16),
	"growing": Rect2(16, 48, 16, 16),
	"harvestable": Rect2(16, 64, 16, 32)
}

var defaultTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16)
}

func _ready() -> void:
	tileType = "farmTile"
	setType("default")
	
	if randi() % 2 == 0:
		$Sprite.flip_h = true
	add_to_group("farmTiles")
	inFrontOfPlayer = true
	stateIndex = 0
	updateTexture()
	
	#GlobalFarmTileManager.wheetGrowPerMinute += ((GlobalFarmTileManager.tickSpeed)/growSpeed)
	GlobalFarmTileManager.allFarmTiles.append(self)
	manageBlending()
	updateWaterTiles()

func getData():
	var nodeData = {}
	nodeData["group"] = "farmTiles"
	nodeData["position"] = position
	nodeData["stateIndex"] = stateIndex
	nodeData["cropType"] = cropType
	return nodeData

func updateTexture():
	if waterSources.size() > 0 and stateIndex == 0:
		stateIndex = 1
		
	elif waterSources.size() == 0 and stateIndex == 1:
		stateIndex = 0
		
	var currentState = tileState[stateIndex]	
	if currentState in currentTextureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = currentTextureRegions[currentState]
		sprite.texture = atlas  #apply the new texture region
		
		
	if currentState == "harvestable":
		sprite.offset.y = -8  #move it down by 16 pixels
	else:
		sprite.offset.y = 0  #reset for other states
	
	if tileState[stateIndex] == "harvestable":
		harvestable = true;
	if tileState[stateIndex] != "harvestable":
		harvestable = false;
	manageBlending()

	
	#print("New texture: " + str(currentState))
		
func advanceState():
	if randi_range(1,growSpeed) == 1:
		if stateIndex > 1 and stateIndex < 4: #is seeded but not fully grown
			stateIndex += 1 
			updateTexture()
			if stateIndex == 4:
				$AnimationPlayer.play("grow")

func harvestCrop():
	if harvestable:
		createHarvestParticle()
		if waterSources.size() > 0:
			stateIndex = 1 #return to firtile
		if waterSources.size() == 0:
			stateIndex = 0
		updateTexture()

		match cropType:
			"wheat":
				player.inventory["wheat"] += randi_range(1,2)
			"corn":
				player.inventory["corn"] += randi_range(1,2)
				
		player.hotBar.updateAmounts("items")
func seedCrop(newType = null):
	var typeToPlant = newType if newType != null else cropType
	match typeToPlant:
		"wheat":
			if player.inventory["wheat"]>= 1:
				if newType:
					setType(newType)
				stateIndex = 2
				updateTexture()
				player.inventory["wheat"] -= 1 
		"corn":
			if player.inventory["corn"] >= 1:
				if newType:
					setType(newType)
				stateIndex = 2
				updateTexture()
				player.inventory["corn"] -= 1 
		
func setType(type:String):
	if type == "default":
		currentTextureRegions = defaultTextureRegions
	if type == "wheat":
		cropType = type
		currentTextureRegions = wheatTextureRegions
		currentHarvestParticle = wheatParticlePreload
		
	if type == "corn":
		cropType = type
		currentTextureRegions = cornTextureRegions
		currentHarvestParticle = cornPartilePreload
	cropType = type
	updateTexture()

	
func _on_hit_box_area_entered(area: Area2D) -> void:
	
	super.findCurrentCollisions(area, true)
	
func _on_hit_box_area_exited(area: Area2D) -> void:
	super.findCurrentCollisions(area, false)

func createHarvestParticle():
	var particle = currentHarvestParticle.instantiate()
	particle.position = self.position
	particle.get_child(0).emitting = true
	get_parent().get_parent().add_child(particle)
	particle.add_to_group("harvest")
	await get_tree().create_timer(1).timeout
	particle.queue_free()


func updateWaterTiles():
	for tile in get_tree().get_nodes_in_group("waterTiles"):
		if position.distance_to(tile.position) <= 44:  #44 makes circle  46 makes square
			if tile not in waterSources:
				waterSources[tile] = true
		updateTexture()
