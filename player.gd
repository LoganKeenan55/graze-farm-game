extends CharacterBody2D

var speed: int = 96
var mode = "nothing" # nothing, placing, farming, seed

var inventory= {
	"farmTile": 50,"waterTile" :50 , "brickTile":5 , "autoFarmTile":5,
	"wheat":10, "corn":10
}

var currentTile = 0
var placeableTiles = ["farmTile", "waterTile", "brickTile", "autoFarmTile"]

var currentItem = 0
var items = ["hoe", "shovel", "seeds"]

var currentSeed = 0
var harvestables = ["wheat", "corn"]

var autoFarmTilePreload = preload("res://AutoFarmTile.tscn")
var farmTilePreload = preload("res://FarmTile.tscn")
var waterTilePreload = preload("res://WaterTile.tscn")
var brickTilePreload = preload("res://BrickTile.tscn")
var textureAtlasPreload = preload("res://TexturePreview.tscn")
var TilePreview

@onready var hotBar = get_node("HUD/HotBar")

func _ready() -> void:
	add_to_group("player")
	
	hotBar.setTexture("items",2,harvestables[currentSeed])
func getData():
	return {
		"group": "player",
		"position": position,
		"inventory": inventory
	}

func getInput():
	if Input.is_action_just_pressed("p"):
		GlobalVars.saveGame()
	if Input.is_action_just_pressed("l"):
		GlobalVars.loadGame()

	var inputDirection = Input.get_vector("a", "d", "w", "s")
	velocity = inputDirection * speed
	if inputDirection.x > 0:
		$Player_Sprites/AnimationPlayer.play("right")
	elif inputDirection.x < 0:
		$Player_Sprites/AnimationPlayer.play("left")
	else:
		$Player_Sprites/AnimationPlayer.play("straight")
		
		
	if Input.is_action_just_pressed("e"): # placing mode
		
		if mode != "placing":
			if mode == "seed":
				hotBar.setMode("noseed")
			mode = "placing"
			createTilePreview()
			$Cursor.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			hotBar.setMode("placing")
		else:
			mode = "nothing"
			freeTilePreview()
			hotBar.setMode("nothing")

	if Input.is_action_just_pressed("f"): # farming mode
		if mode != "farming":
			if mode == "seed":
				hotBar.setMode("noseed")
			mode = "farming"
			freeTilePreview()
			hotBar.setMode("farming")
			$Cursor.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			mode = "nothing"
			freeTilePreview()
			$Cursor.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Cursor.updateTexture()
			hotBar.setMode("nothing")

func _process(_delta: float) -> void:
	getInput()
	handleMode()

func _physics_process(delta):
	move_and_slide()

func createTile(type):
	var tilePosition = Vector2(
		snapped(get_global_mouse_position().x, 16),
		snapped(get_global_mouse_position().y, 16)
	)

	var tilesParent = get_tree().current_scene.find_child("Tiles", true, false)
	var underTilesParent = get_tree().current_scene.find_child("UnderTiles", true, false)

	for child in tilesParent.get_children():
		if child.position == tilePosition:
			return
	for child in underTilesParent.get_children():
		if child.position == tilePosition:
			return
	
	if inventory[type]<1:
		return

	var newTile
	match type:
		
		"farmTile":
			
			newTile = farmTilePreload.instantiate()
			newTile.position = tilePosition
			tilesParent.add_child(newTile)
			inventory["farmTile"] -= 1
			
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
			
	hotBar.setAmount("tiles",placeableTiles.find(type),inventory[type])
	if newTile:
		sortTilesByY(tilesParent)
	
func freeTilePreview():
	if TilePreview:
		TilePreview.queue_free()

func createTilePreview():
	if TilePreview == null:
		TilePreview = textureAtlasPreload.instantiate()
		TilePreview.stateIndex = currentTile
		get_parent().add_child(TilePreview)
		TilePreview.isBeingUsed = true
		TilePreview.position = Vector2(snapped(get_global_mouse_position().x, 16), snapped(get_global_mouse_position().y, 16))

func handleMode():
	match mode:
		"nothing":
			pass

		"placing":
			for i in range(1, 5):
				if Input.is_action_just_pressed(str(i)):
					currentTile = i - 1
					if TilePreview:
						TilePreview.stateIndex = currentTile
						TilePreview.updateTexture()
					hotBar.updateSelected("tiles", currentTile)

			if Input.is_action_pressed("left_click") and !GlobalFarmTileManager.overTile:
				createTile(placeableTiles[currentTile])

		"farming":
			for i in range(1, 4):
				if Input.is_action_just_pressed(str(i)):
					currentItem = i - 1
					$Cursor.item = currentItem
					$Cursor.updateTexture()
					
					#if we're already on the same item (same index) and pressed again, open the second menu
					if hotBar.isSelected("items", currentItem):
						hotBar.setMode("seed")
						mode = "seed"
					else:
						hotBar.updateSelected("items", currentItem)

		"seed":
			for i in range(1, 3):
				if Input.is_action_just_pressed(str(i)):
					currentSeed = i - 1
					hotBar.setTexture("items",2,harvestables[currentSeed])
					hotBar.updateSelected("seeds", currentSeed)
					hotBar.setMode("noseed")
					mode = "farming"
					$Cursor.updateTexture()

func sortTilesByY(parentNode):
	var tiles = parentNode.get_children()
	tiles.sort_custom(func(a, b): return a.position.y < b.position.y)
	for i in range(tiles.size()):
		parentNode.move_child(tiles[i], i)
