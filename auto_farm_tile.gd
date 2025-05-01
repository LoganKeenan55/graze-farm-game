extends "res://tile.gd"

var level = 0
var range = 46

var cropType = "corn"

var sound = "res://sounds/metal_sound.mp3"
var tileState = ["level1","level2"]

var textureRegions = {
	"level1": Rect2(16, 112, 16, 16),
}



var level1TextureRegions = {
	"corn":Rect2(112, 0, 16, 16),
	"wheat":Rect2(96, 0, 16, 16),
}

var level2TextureRegions = {
	"corn":Rect2(224, 16, 16, 16),
	"wheat":Rect2(240, 16, 16, 16),
}

var currentTextureRegions: Dictionary

func _ready() -> void:
	currentTextureRegions = level1TextureRegions
	add_to_group("autoFarmerTiles")
	sprite = $Sprite 
	usesBlending = false
	tileType = "autoFarmTile"
	updateTexture()
func getData():
	var nodeData = {}
	nodeData["group"] = "autoFarmerTiles"
	nodeData["position"] = position
	nodeData["level"] = level
	return nodeData

func updateTexture(): 
	var currentState = tileState[stateIndex] #Base Texture
	if currentState in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[currentState]
		sprite.texture = atlas
	
	if cropType in currentTextureRegions: #Crop Texture
		var CropAtlas = AtlasTexture.new()
		CropAtlas.atlas = atlasTexture
		CropAtlas.region = currentTextureRegions[cropType]
		$cropTexture.texture = CropAtlas
	manageBlending()

func updateLevel(newlev):
	level = newlev
	updateTexture()
	print(level)

func harvestFarmTiles():
	for tile in get_tree().get_nodes_in_group("farmTiles"):
		if position.distance_to(tile.position) <= range:  #44 makes circle  46 makes square
			if tile.harvestable:
				tile.harvestCrop()

func plantFarmTiles():
	for tile in get_tree().get_nodes_in_group("farmTiles"):
		if position.distance_to(tile.position) <= range:  #44 makes circle  46 makes square
			if tile.tileState[tile.stateIndex] == "fertile" and tile.cropType != "default":
				tile.seedCrop()

func activate():
	$AnimationPlayer.play("activate")
	harvestFarmTiles()
	plantFarmTiles()
