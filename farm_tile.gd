extends "res://tile.gd"
class_name FarmTile

@onready var player = $HitBox.player
@onready var playerCol = $PlayerCollision
@onready var blend = $Blend
var wheatParticlePreload = preload("res://WheatHarvestParticle.tscn")
var cornPartilePreload = preload("res://CornHarvestParticle.tscn")
var bambooParticlePreload = preload("res://bamboo_harvest_particle.tscn")
var berryParticlePreload = preload("res://berryHarvestParticle.tscn")
var onionParticlePreload = preload("res://OnionHarvestParticle.tscn")
var flowerParticlePreload = preload("res://FlowerHarvestParticle.tscn")
var pepperParticlePreload = preload("res://PepperHarvestParticle.tscn")

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
var berryTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(48, 32, 16, 16),
	"growing": Rect2(48, 48, 16, 16),
	"harvestable": Rect2(48, 64, 16, 32)
}
var onionTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(64, 32, 16, 16),
	"growing": Rect2(64, 48, 16, 16),
	"harvestable": Rect2(64, 64, 16, 32)
}
var flowerTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(80, 32, 16, 16),
	"growing": Rect2(80, 48, 16, 16),
	"harvestable": Rect2(80, 64, 16, 32)
}
var pepperTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16),
	"seeded": Rect2(96, 32, 16, 16),
	"growing": Rect2(96, 48, 16, 16),
	"harvestable": Rect2(96, 64, 16, 32)
}

var defaultTextureRegions = {
	"unfertile": Rect2(0, 0, 16, 16),
	"fertile": Rect2(0, 16, 16, 16)
}

var growSpeeds = { #there is a 1/growSpeed chance every .5 sec, def = 30
	"wheat": 20,
	"corn": 30,
	"bamboo": 15,
	"berry": 60,
	"onion": 20,
	"flower": 30,
	"pepper": 50
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
					"onion":
						SoundManager.play_sound("res://sounds/bloop4.mp3",position)
					"berry":
						SoundManager.play_sound("res://sounds/bloop5.mp3",position,.32)
					"flower":
						SoundManager.play_sound("res://sounds/bloop6.mp3",position,.1)
					"pepper":
						SoundManager.play_sound("res://sounds/bloop7.mp3",position,.1)
						SoundManager.play_sound("res://sounds/sizzle.mp3",position,.1)
					_:
						print("INVALID TYPE in function: advanceState")
func harvestCrop():
	if harvestable:
		
		createHarvestParticle()
		if waterSources.size() > 0:
			if cropType == "berry":
				stateIndex = 3
			else:
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
			"berry":
				player.inventory[cropType] += randi_range(1,2)
			"onion":
				player.inventory[cropType] += randi_range(1,2)
			"flower":
				player.inventory[cropType] += randi_range(1,2)
			"pepper":
				player.inventory[cropType] += randi_range(1,2)
				SoundManager.play_sound("res://sounds/sizzle.mp3",position,.1)
			_:
				print("INVALID TYPE in function: harvestCrop")
		player.hotBar.updateAmounts("items") #update hotbar
		player.hud.updateCounter(cropType)
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
	
func setType(type:String):
	match type:
		"default":
			currentTextureRegions = defaultTextureRegions
		"wheat":
			cropType = type
			currentTextureRegions = wheatTextureRegions
			currentHarvestParticle = wheatParticlePreload
		"corn":
			cropType = type
			currentTextureRegions = cornTextureRegions
			currentHarvestParticle = cornPartilePreload
		"bamboo":
			cropType = type
			currentTextureRegions = bambooTextureRegions
			currentHarvestParticle = bambooParticlePreload
		"berry":
			cropType = type
			currentTextureRegions = berryTextureRegions
			currentHarvestParticle = berryParticlePreload
		"onion":
			cropType = type
			currentTextureRegions = onionTextureRegions
			currentHarvestParticle = onionParticlePreload
		"flower":
			cropType = type
			currentTextureRegions = flowerTextureRegions
			currentHarvestParticle = flowerParticlePreload
		"pepper":
			cropType = type
			currentTextureRegions = pepperTextureRegions
			currentHarvestParticle = pepperParticlePreload
		
		_:
			print("INVALID TYPE in function: setType in farm_tile.gd")
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
