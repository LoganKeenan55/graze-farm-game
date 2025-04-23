extends "res://tile.gd"

var sound = "res://sounds/brick_sound.mp3"

func _ready() -> void:
	tileType = "brickTile"
	add_to_group("brickTiles")
	inFrontOfPlayer = false
	manageBlending()
	
func getData():
	var nodeData = {}
	nodeData["group"] = "brickTiles"
	nodeData["position"] = position
	return nodeData
	
func _on_hit_box_area_entered(area: Area2D) -> void:
	super.findCurrentCollisions(area,true)


func _on_hit_box_area_exited(area: Area2D) -> void:
	super.findCurrentCollisions(area,false)
