extends Node2D

func _ready() -> void:
	var tiles = get_children()
	tiles.sort_custom(func(a, b): return a.position.y < b.position.y)
	for i in range(tiles.size()):
		move_child(tiles[i], i)
