extends Node


var textureRegions = {
	"farmTile": Rect2(0, 0, 16, 16),
	"waterTile": Rect2(0, 96, 16, 16),
	"brickTile": Rect2(0,128 ,16 ,16),
	"autoFarmTile": Rect2(16, 112, 16, 16),
	
	"hoe": Rect2(240, 0, 16, 16),
	"seeds": Rect2(240, 16, 16, 16),
	"shovel": Rect2(208, 0, 16, 16),
	"hammer": Rect2(224, 0, 16, 16), 
	"cursor": Rect2(192, 0, 16, 16),
	
	"corn":Rect2(112, 0, 16, 16),
	"wheat":Rect2(96, 0, 16, 16),
	"bamboo": Rect2(128, 0, 16, 16),
	"default": 	Rect2(500, 0, 16, 16),
	
	"wheatSeeds":Rect2(240, 16, 16, 16),
	"cornSeeds":Rect2(224, 16, 16, 16),
	"bambooSeeds":Rect2(208, 16, 16, 16),
}

var timeSinceLastSave

var farmTilePreload = preload("res://FarmTile.tscn")
var waterTilePreload = preload("res://WaterTile.tscn")
var brickTilePreload = preload("res://BrickTile.tscn")
var autoFarmerTilePreload = preload("res://AutoFarmTile.tscn")
@onready var player = get_tree().current_scene.get_node("Player")
@onready var tilesParent = get_tree().current_scene.get_node("Tiles")
@onready var underTilesParent = get_tree().current_scene.get_node("UnderTiles")


func saveGame():
	print("saving...")
	var saveData = []  #List that stores dictionaries for all data for all nodes
	saveData.append({"group": "time","globalTime": Time.get_unix_time_from_system()})
	saveData.append(player.getData())
	
	for node in tilesParent.get_children(): #tiles
		if node.has_method("getData"):
			saveData.append(node.getData()) #adds all nodes in Tiles
		else:
			print("tried to save " + str(node))
	
	for node in underTilesParent.get_children(): #underTiles
		if node.has_method("getData"):
			saveData.append(node.getData()) #adds all nodes in UnderTiles
		else:
			print("tried to save " + str(node))
	
	var filePath = "C:/GodotGames/farmGameSaveFiles/save_game.save"
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(saveData)
	file.close()
	
	print("saved!")

func loadGame():
	print("loading...")
	var file_path = "C:/GodotGames/farmGameSaveFiles/save_game.save"
	var file = FileAccess.open(file_path, FileAccess.READ)
	var saveData = file.get_var()
	file.close()
	
	deleteAllTiles()
	
	
	
	for node in saveData:
		var newTile
		if node["group"] == "time": #sets time since last saveawl
			timeSinceLastSave = abs(node["globalTime"] - Time.get_unix_time_from_system())
		if node["group"] == "player":
			player.position = node["position"]
			player.inventory.clear()
			for key in node["inventory"]:
				player.inventory[key] = node["inventory"][key]
		if node["group"] == "farmTiles":
			newTile = farmTilePreload.instantiate()
			newTile.position = node["position"]
			newTile.stateIndex = node["stateIndex"]
			newTile.call_deferred("setType", node["cropType"])
			
			tilesParent.add_child(newTile)
			newTile.stateIndex = node["stateIndex"]
		
		if node["group"] == "waterTiles":
			newTile = waterTilePreload.instantiate()
			newTile.position = node["position"]
			tilesParent.add_child(newTile)
		if node["group"] == "brickTiles":
			newTile = brickTilePreload.instantiate()
			newTile.position = node["position"]
			underTilesParent.add_child(newTile)
		if node["group"] == "autoFarmerTiles":
			newTile = autoFarmerTilePreload.instantiate()
			newTile.position = node["position"]
			newTile.level = node["level"]
			underTilesParent.add_child(newTile)
	player.hotBar.updateAmounts("items")
	player.hotBar.updateAmounts("tiles")
	player.hotBar.updateAmounts("seeds")
	
	print("It has been " + str(int(timeSinceLastSave)) + " seconds since last saved")
	print("loaded!")

func deleteAllTiles():
	for node in tilesParent.get_children():
		node.queue_free()
	for node in underTilesParent.get_children():
		node.queue_free()
