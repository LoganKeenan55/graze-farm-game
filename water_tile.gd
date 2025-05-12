extends "res://tile.gd"

var tileState = ["water1","water2"]
var sound = "res://sounds/water_sound.mp3"
var flowSpeed:int = 2 #there is a 1/flowSpeed chance every .5 sec, def = 30



var textureRegions = {
	"water1": Rect2(0, 96, 16, 16),
	"water2": Rect2(16, 96, 16, 16)
}

func _ready() -> void:
	$HitBox.createRemoveParticle()
	add_to_group("waterTiles")
	tileType = "waterTile"
	inFrontOfPlayer = true
	updateTexture()
	updateFertileTiles(1)

func getData():
	var nodeData = {}
	nodeData["group"] = "waterTiles"
	nodeData["position"] = position
	return nodeData
func updateTexture():
	var currentState = tileState[stateIndex]
	if currentState in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[currentState]
		sprite.texture = atlas  #apply the new texture region
	manageBlending()
	
func flow():
	if randi_range(1,flowSpeed) == 1:
		if stateIndex == 0:
			stateIndex = 1 
			updateTexture()
			return
		if stateIndex == 1:
			stateIndex = 0
			updateTexture()
			return
		
		
		
func updateFertileTiles(add_water: int):
	for tile in get_tree().get_nodes_in_group("farmTiles"):
		if position.distance_to(tile.position) <= 44:  #44 makes circle  46 makes square
			if add_water > 0:
				tile.waterSources[self] = true
			elif add_water < 0 and self in tile.waterSources:
				tile.waterSources.erase(self)  
			
			tile.updateTexture()
			
			
func _on_hit_box_area_entered(area: Area2D) -> void:
	super.findCurrentCollisions(area,true)


func _on_hit_box_area_exited(area: Area2D) -> void:
	super.findCurrentCollisions(area,false)
