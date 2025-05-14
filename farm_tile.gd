extends "res://tile.gd"
class_name FarmTile

@onready var player = $HitBox.player


var wheatParticlePreload = preload("res://WheatHarvestParticle.tscn")
var cornPartilePreload = preload("res://CornHarvestParticle.tscn")
var bambooParticlePreload = preload("res://bamboo_harvest_particle.tscn")
var tileState = ["unfertile", "fertile", "seeded", "growing", "harvestable"]

var cropType = "default" #what kind of crop

var waterSources = {} #dictionary of all waterSources
var sound = "res://sounds/dirt_sound.mp3"


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

var bambooTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(32, 32, 16, 16),
	"growing": Rect2(32, 48, 16, 16),
	"harvestable": Rect2(32, 64, 16, 32)
}

var defaultTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16)
}

var growSpeeds = { #there is a 1/growSpeed chance every .5 sec, def = 30
	"wheat": 20,
	"corn": 30,
	"bamboo": 15,
}

func _ready() -> void:
	add_to_group("farmTiles")
	tileType = "farmTile"
	setType("default")
	
	if randi() % 2 == 0:
		$Sprite.flip_h = true
	
	inFrontOfPlayer = true
	stateIndex = 0
	
	
	#GlobalFarmTileManager.wheetGrowPerMinute += ((GlobalFarmTileManager.tickSpeed)/growSpeed)
	GlobalFarmTileManager.allFarmTiles.append(self)
	updateTexture()
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
	if cropType == "default":
		return
	if randi_range(1,growSpeeds[cropType]) == 1:
		if stateIndex > 1 and stateIndex < 4: #is seeded but not fully grown
			stateIndex += 1 
			updateTexture()
			if stateIndex == 4: #fully grown
				$AnimationPlayer.play("grow")
				match cropType:
					"wheat":
						SoundManager.play_sound("res://sounds/bloop1.mp3",position,.1)
					"corn":
						SoundManager.play_sound("res://sounds/bloop2.mp3",position,.1)
					"bamboo":
						SoundManager.play_sound("res://sounds/bloop3.mp3",position)

func harvestCrop():
	if harvestable:
		createHarvestParticle()
		if waterSources.size() > 0:
			stateIndex = 1 #return to firtile
		if waterSources.size() == 0:
			stateIndex = 0
		updateTexture()
	
		match cropType: #add to inventory
			"wheat":
				player.inventory[cropType] += randi_range(1,2)
			"corn":
				player.inventory[cropType] += randi_range(1,2)
			"bamboo":
				player.inventory[cropType] += randi_range(1,2)
				SoundManager.play_sound("res://sounds/bloop3.mp3",position,.1)
				
		player.hotBar.updateAmounts("items") #update hotbar
		
		SoundManager.play_sound("res://sounds/harvest_sound.mp3", position)
		
func seedCrop(newType = null):
	var typeToPlant = newType if newType != null else cropType
	if player.inventory[typeToPlant]>= 1:
		if newType:
			setType(newType)
		stateIndex = 2
		updateTexture()
		player.inventory[typeToPlant] -= 1 
		SoundManager.play_sound("res://sounds/seed_sound.mp3", position)
	#match typeToPlant:
		#"wheat":
			#if player.inventory["wheat"]>= 1:
				#if newType:
					#setType(newType)
				#stateIndex = 2
				#updateTexture()
				#player.inventory["wheat"] -= 1 
				#SoundManager.play_sound("res://sounds/seed_sound.mp3", position)
		#"corn":
			#if player.inventory["corn"] >= 1:
				#if newType:
					#setType(newType)
				#stateIndex = 2
				#updateTexture()
				#player.inventory["corn"] -= 1 
				#SoundManager.play_sound("res://sounds/seed_sound.mp3", position)
		#"bamboo":
			#if player.inventory["bamboo"] >= 1:
				#if newType:
					#setType(newType)
				#stateIndex = 2
				#updateTexture()
				#player.inventory["bamboo"] -= 1 
				#SoundManager.play_sound("res://sounds/seed_sound.mp3", position)
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
		
	if type == "bamboo":
		cropType = type
		currentTextureRegions = bambooTextureRegions
		currentHarvestParticle = bambooParticlePreload
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
