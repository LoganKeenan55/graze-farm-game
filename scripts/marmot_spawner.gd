extends Node2D

var marmotPreload = preload("res://scenes/Marmot.tscn")
var goalTile:Node

var marmotArr = []

@export var player:Node

func _ready() -> void:
	GlobalFarmTileManager.connect("spawnMarmot", Callable(self, "spawnMarmot"))

func pickFarmTile() -> Node: #returns random farmTile node
	var farmTiles = get_tree().get_nodes_in_group("farmTiles")
	
	if farmTiles.is_empty():
		return null
	
	var ammountOfTiles = farmTiles.size()
	var randomIndex = randi_range(0,ammountOfTiles-1)
	var tile = farmTiles[randomIndex]
	if tile.stateIndex < 2:
		return null
	goalTile = tile
	for marmot in marmotArr:
		if marmot.goal == tile:
			return null
	return tile

func findPlaceToSpawnMarmot() -> Vector2: #760 1450
	var randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
	while(!isMarmotSpawnValid(randomVector)):
		randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
		
	return randomVector

func isMarmotSpawnValid(randVec) -> bool:
	var tilesParent = get_tree().current_scene.find_child("Tiles", true, false)
	var temp
	
	
	if randVec.distance_to(player.position) <= 100: #too close to player
		return false
	
	
	var hasNearbyTile = false
	
	for node in tilesParent.get_children():
		if node.position.distance_to(randVec) <= 16: #too close to tile any
			return false
	
		if node.position.distance_to(randVec) > 500: #not close enough to tile
			hasNearbyTile = true
			
	
	return hasNearbyTile



func spawnMarmot() -> void:
	var newMarmot = marmotPreload.instantiate()
	goalTile = pickFarmTile()
	if goalTile == null:
		return
	newMarmot.position = findPlaceToSpawnMarmot()
	newMarmot.goal = goalTile
	#newMarmot.navAgent.target_position = goalTile.position
	add_child(newMarmot)
	marmotArr.append(newMarmot)
