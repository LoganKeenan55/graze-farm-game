extends Node2D

var marmotPreload = preload("res://Marmot.tscn")
var goalTile:Node

@export var player:Node

func pickFarmTile() -> Node: #returns random farmTile node
	var farmTiles = get_tree().get_nodes_in_group("farmTiles")
	
	if farmTiles.is_empty():
		return null
	
	var ammountOfTiles = farmTiles.size()
	var randomIndex = randi_range(0,ammountOfTiles-1)
	var tile = farmTiles[randomIndex]
	goalTile = tile
	return tile

func findPlaceToSpawnMarmot() -> Vector2: #760 1450
	var randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
	while(!isMarmotSpawnValid(randomVector)):
		randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
		
	return randomVector

func isMarmotSpawnValid(randVec) -> bool:
	var tilesParent = get_tree().current_scene.find_child("Tiles", true, false)
	for node in tilesParent.get_children():
		if node.position.distance_to(randVec) <= 16:
			return false
		if randVec.distance_to(player.position) <= 50:
			return false
	return true


func spawnMarmot() -> void:
	var newMarmot = marmotPreload.instantiate()
	goalTile = pickFarmTile()
	if goalTile == null:
		print("cannot spawn marmot: NO FARMTILES AVALIBLE")
		return
	newMarmot.position = findPlaceToSpawnMarmot()
	newMarmot.goal = goalTile
	#newMarmot.navAgent.target_position = goalTile.position
	get_parent().add_child(newMarmot)
