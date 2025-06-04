extends Node2D
##
@onready var player = get_parent()
#
@onready var inventory = player.inventory
@onready var hotBar 
##
@onready var currentTile = player.currentTile
@onready var placeableTiles = player.placeableTiles
##
@onready var currentItem = player.currentItem
@onready var items = player.items
##
@onready var currentSeed = player.currentSeed
@onready var harvestables = player.harvestables

##
var autoFarmTilePreload = preload("res://AutoFarmTile.tscn")
var farmTilePreload = preload("res://FarmTile.tscn")
var waterTilePreload = preload("res://WaterTile.tscn")
var brickTilePreload = preload("res://BrickTile.tscn")
var textureAtlasPreload = preload("res://TexturePreview.tscn")
##

var tilePreview

func createTile(type):
	var tilePosition = Vector2(
		snapped(get_global_mouse_position().x, 16),
		snapped(get_global_mouse_position().y, 16)
	)

	var tilesParent = get_tree().current_scene.find_child("Tiles", true, false)
	var underTilesParent = get_tree().current_scene.find_child("UnderTiles", true, false)
	
	if inventory[type]<1:
		return
		
	var freedTile = null #temp variable to keep access to the destroyed tile
	
	for child in tilesParent.get_children():
		if child.position == tilePosition:
			if child.tileType == type: #check to insure that it won't endlessly replace the same tile
				return
			if child.tileType == "waterTile":
				freedTile = child
			child.hitbox.handleDeletingTile()
	
	for child in underTilesParent.get_children():
		if child.position == tilePosition:
			if child.tileType == type: #check to insure that it won't endlessly replace the same tile
				return
			child.hitbox.handleDeletingTile()
	

	var newTile
	match type:
		
		"farmTile":
			newTile = farmTilePreload.instantiate()
			newTile.position = tilePosition
			tilesParent.add_child(newTile)
			inventory["farmTile"] -= 1
			newTile.updateWaterTiles()

			if freedTile != null: #fixes bug with waterTile staying fertile
				newTile.waterSources.erase(freedTile)
				newTile.updateTexture()
				
		"waterTile":
			newTile = waterTilePreload.instantiate()
			newTile.position = tilePosition
			tilesParent.add_child(newTile)
			inventory["waterTile"] -= 1
			
		"brickTile":
			newTile = brickTilePreload.instantiate()
			newTile.position = tilePosition
			underTilesParent.add_child(newTile)
			inventory["brickTile"] -= 1
			
		"autoFarmTile":
			newTile = autoFarmTilePreload.instantiate()
			newTile.position = tilePosition
			underTilesParent.add_child(newTile)
			inventory["autoFarmTile"] -= 1
		_:
			print("INVALID TYPE in function: createTile")
	
	hotBar.setAmount("tiles",placeableTiles.find(type),inventory[type])
	SoundManager.play_sound(newTile.sound)
	if newTile:
		sortTilesByY(tilesParent)

func createTilePreview():
	if tilePreview == null:
		tilePreview = textureAtlasPreload.instantiate()
		tilePreview.stateIndex = currentTile
		get_parent().get_parent().add_child(tilePreview)
		tilePreview.isBeingUsed = true
		tilePreview.position = Vector2(snapped(get_global_mouse_position().x, 16), snapped(get_global_mouse_position().y, 16))

func freeTilePreview():
	if tilePreview:
		tilePreview.queue_free()

func sortTilesByY(parentNode):
	var tiles = parentNode.get_children()
	tiles.sort_custom(func(a, b): return a.position.y < b.position.y)
	for i in range(tiles.size()):
		parentNode.move_child(tiles[i], i)
