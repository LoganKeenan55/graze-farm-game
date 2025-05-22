extends CharacterBody2D

## onready
@onready var tileComponent = $TileComponent
@onready var hotBar = $HUD/HotBar

## preload
var shopMenuPreload = preload("res://ShopMenu.tscn")
var dustParticlePreload = preload("res://DustParticle.tscn")
## player variables
var speed: int = 96
var mode = "nothing" # nothing, placing, farming, seed, shop

## inventory dictionary
var inventory= {
	"farmTile": 50,"waterTile" :50 , "brickTile":50 , "autoFarmTile":5,
	"wheat":10, "corn":10, "bamboo": 20
}

## tiles
var currentTile = 0
var placeableTiles = ["farmTile", "waterTile", "brickTile", "autoFarmTile"]

## items
var currentItem = 0
var items = ["hoe", "shovel", "seeds", "hammer"]

## seeds
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

func getInput():
	handleSavingLoadingGame()
	handleMovement()
	handleChangingMode()
	handleCheats()
	handleMode()

func handleCheats():
	if Input.is_action_just_pressed("c"): #9999 of everything 
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
	if Input.is_action_just_pressed("e"):
		switch_to_mode("placing")

	elif Input.is_action_just_pressed("f"):
		switch_to_mode("farming")

	elif Input.is_action_just_pressed("tab"):
		toggle_shop_mode()


func switch_to_mode(new_mode: String):
	if mode == new_mode:
		reset_to_nothing()
		return

	if mode == "seed":
		hotBar.setMode("noseed")

	mode = new_mode
	$Cursor.updateTexture()
	tileComponent.freeTilePreview()
	tileComponent.createTilePreview() if new_mode == "placing" else null
	hotBar.setMode(new_mode)
	close_shop_if_open()


func toggle_shop_mode():
	tileComponent.freeTilePreview()
	var existing_menu = get_node_or_null("ShopMenu")

	if mode == "shop":
		mode = "nothing"
		hotBar.setMode("nothing")
		if existing_menu:
			existing_menu.anPlayer.play("close")
			SoundManager.play_sound("res://sounds/book_close.mp3", Vector2.ZERO, 0.3)
	else:
		if existing_menu:
			return
		hotBar.setMode("noseed") #gets rid of seed hud
		mode = "shop"
		
		hotBar.setMode("nothing")
		var shop_menu = shopMenuPreload.instantiate()
		shop_menu.name = "ShopMenu"
		add_child(shop_menu)
		shop_menu.anPlayer.play("open")
		SoundManager.play_sound("res://sounds/book_sound.mp3")
		$Cursor.updateTexture()


func reset_to_nothing():
	mode = "nothing"
	tileComponent.freeTilePreview()
	$Cursor.updateTexture()
	hotBar.setMode("nothing")


func close_shop_if_open():
	var existing_menu = get_node_or_null("ShopMenu")
	if existing_menu:
		existing_menu.queue_free()
		
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

func handleMode(): #handles changing mode
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
					if hotBar.isSelected("items", currentItem) and i == 3:
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

func play_walk_sound():
	SoundManager.play_sound("res://sounds/grass_walk.mp3",Vector2.ZERO,.4)
	var particle = dustParticlePreload.instantiate()
	particle.position.y = position.y+8
	particle.position.x = position.x
	particle.get_child(0).emitting = true
	get_parent().get_node("UnderTiles").add_child(particle)
