extends CharacterBody2D
##
@onready var tileComponent = $TileComponent
@onready var hotBar = $HUD/HotBar
##
var speed: int = 96
var mode = "nothing" # nothing, placing, farming, seed
##
var inventory= {
	"farmTile": 50,"waterTile" :50 , "brickTile":50 , "autoFarmTile":5,
	"wheat":10, "corn":10, "bamboo": 20
}
##
var currentTile = 0
var placeableTiles = ["farmTile", "waterTile", "brickTile", "autoFarmTile"]
##
var currentItem = 0
var items = ["hoe", "shovel", "seeds", "hammer"]
##
var currentSeed = 0
var harvestables = ["wheat", "corn", "bamboo"]
##


func _ready() -> void:
	add_to_group("player")
	$TileComponent.hotBar = hotBar

func _physics_process(delta):
	move_and_slide()

func _process(_delta: float) -> void:
	getInput()
	handleMode()

func getInput():
	handleSavingLoadingGame()
	handleMovement()
	handleChangingMode()
	if Input.is_action_just_pressed("c"): #cheat
		inventory["farmTile"] = 9999
		inventory["waterTile"] = 9999
		inventory["autoFarmTile"] = 9999
		inventory["brickTile"] = 9999
		inventory["wheat"] = 9999
		inventory["corn"] = 9999
		inventory["bamboo"] = 9999
		hotBar.updateAll()

func getData():
	return {
		"group": "player",
		"position": position,
		"inventory": inventory
	}

func handleChangingMode():
	if Input.is_action_just_pressed("e"): # placing mode
		
		if mode != "placing":
			if mode == "seed":
				hotBar.setMode("noseed")
			mode = "placing"
			tileComponent.createTilePreview()
			$Cursor.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			hotBar.setMode("placing")
		else:
			mode = "nothing"
			tileComponent.freeTilePreview()
			hotBar.setMode("nothing")

	if Input.is_action_just_pressed("f"): # farming mode
		if mode != "farming":
			if mode == "seed":
				hotBar.setMode("noseed")
			mode = "farming"
			tileComponent.freeTilePreview()
			hotBar.setMode("farming")
			$Cursor.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			mode = "nothing"
			tileComponent.freeTilePreview()
			$Cursor.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Cursor.updateTexture()
			hotBar.setMode("nothing")

func handleSavingLoadingGame():
	if Input.is_action_just_pressed("p"):
		GlobalVars.saveGame()
	if Input.is_action_just_pressed("l"):
		GlobalVars.loadGame()

func handleMovement():
	var inputDirection = Input.get_vector("a", "d", "w", "s")
	velocity = inputDirection * speed

	if inputDirection.length_squared() > 0:
		$Player_Sprites/AnimationPlayer.play("walk")
	else:
		$Player_Sprites/AnimationPlayer.play("idle")

	if inputDirection.x > 0: #right
		$Player_Sprites/Head.frame = 1
		$Player_Sprites/Body.frame = 1
		$Player_Sprites/Legs.flip_h = true
	elif inputDirection.x < 0: #left
		$Player_Sprites/Head.frame = 2
		$Player_Sprites/Body.frame = 2
		$Player_Sprites/Legs.flip_h = false
	else: #straight
		$Player_Sprites/Head.frame = 0
		$Player_Sprites/Body.frame = 0

func handleMode():
	match mode:
		"nothing":
			pass
		"placing":
			for i in range(1, 5):
				if Input.is_action_just_pressed(str(i)):
					currentTile = i - 1
					if tileComponent.tilePreview:
						tileComponent.tilePreview.stateIndex = currentTile
						tileComponent.tilePreview.updateTexture()
					hotBar.updateSelected("tiles", currentTile)

			if Input.is_action_pressed("left_click") and !GlobalFarmTileManager.overTile:
				tileComponent.createTile(placeableTiles[currentTile])

		"farming":
			for i in range(1, 5):
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
			for i in range(1, 4):
				if Input.is_action_just_pressed(str(i)):
					currentSeed = i - 1
					hotBar.setTexture("items",2,harvestables[currentSeed])
					hotBar.updateSelected("seeds", currentSeed)
					hotBar.setMode("noseed")
					mode = "farming"
					$Cursor.updateTexture()

#func sortTilesByY(parentNode):
	#var tiles = parentNode.get_children()
	#tiles.sort_custom(func(a, b): return a.position.y < b.position.y)
	#for i in range(tiles.size()):
		#parentNode.move_child(tiles[i], i)
