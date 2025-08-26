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
	"cursor": Rect2(240, 32, 16, 16),
	
	"corn":Rect2(112, 0, 16, 16),
	"wheat":Rect2(96, 0, 16, 16),
	"bamboo": Rect2(128, 0, 16, 16),
	"berry": Rect2(144, 0, 16, 16),
	"onion": Rect2(160, 0, 16, 16),
	"flower": Rect2(176, 0, 16, 16),
	"pepper": Rect2(190, 0, 16, 16),
	"default": 	Rect2(500, 0, 16, 16),
	"questionMark":Rect2(80, 0, 16, 16),
	
	"wheatSeeds":Rect2(240, 16, 16, 16),
	"cornSeeds":Rect2(224, 16, 16, 16),
	"bambooSeeds":Rect2(208, 16, 16, 16),
	"berrySeeds":Rect2(192, 16, 16, 16),
	"onionSeeds":Rect2(176, 16, 16, 16),
	"flowerSeeds":Rect2(176, 32, 16, 16),
	"pepperSeeds":Rect2(192, 32, 16, 16),
}

var timeSinceLastSave
var globalTime:int = 8
var isNewGame := false
var playerGender := "male"
var homeLevel := 1
var autoSave := true
var cheats := false
var farmOnClick := false
##
var farmTilePreload = preload("res://scenes/FarmTile.tscn")
var waterTilePreload = preload("res://scenes/WaterTile.tscn")
var brickTilePreload = preload("res://scenes/BrickTile.tscn")
var autoFarmerTilePreload = preload("res://scenes/AutoFarmTile.tscn")
##
@onready var player:Player
@onready var tilesParent
@onready var underTilesParent 
##
signal save_loaded
##
func saveGame():
	isNewGame = false
	print("saving...")
	var saveData = []  #List that stores dictionaries for all data for all nodes
	saveData.append({"group": "IRLtime","IRLtime": Time.get_unix_time_from_system()})
	saveData.append({"group": "globalTime", "globalTime": globalTime})
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
		if node["group"] == "IRLtime": #sets time since last save
			timeSinceLastSave = abs(node["IRLtime"] - Time.get_unix_time_from_system())
		if node["group"] == "globalTime": #gameTime
			globalTime = node["globalTime"]
		if node["group"] == "player":
			player.position = node["position"]
			player.inventory.clear()
			for key in node["inventory"]:
				player.inventory[key] = node["inventory"][key]
			player.unlockLevel = node["unlockLevel"]
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
			newTile.cropType = node["cropType"]
			newTile.upgradePrices = node["upgradePrices"]
			underTilesParent.add_child(newTile)
	player.hotBar.updateAmounts("items")
	player.hotBar.updateAmounts("tiles")
	player.hotBar.updateAmounts("seeds")
	
	emit_signal("save_loaded")
	print("It has been " + str(int(timeSinceLastSave)) + " seconds since last saved")
	print("loaded!")

func deleteAllTiles():
	for node in tilesParent.get_children():
		node.queue_free()
	for node in underTilesParent.get_children():
		node.queue_free()
