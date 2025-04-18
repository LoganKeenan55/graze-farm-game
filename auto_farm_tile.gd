extends "res://tile.gd"

var level = 0
var range = 46
var textureRegions = {
	"autoFarmTile": Rect2(16, 112, 16, 16),
}

func _ready() -> void:
	add_to_group("autoFarmerTiles")
	sprite = $Sprite 
	usesBlending = false

func getData():
	var nodeData = {}
	nodeData["group"] = "autoFarmerTiles"
	nodeData["position"] = position
	nodeData["level"] = level
	return nodeData

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
