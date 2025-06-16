extends CharacterBody2D

## onready
@onready var tileComponent = $TileComponent
@onready var hotBar = $HUD/HotBar
@onready var hud = $HUD
## preload
var shopMenuPreload = preload("res://ShopMenu.tscn")
var dustParticlePreload = preload("res://DustParticle.tscn")
## player variables
var speed: int = 96
var mode = "nothing" # nothing, placing, farming, seed, shop

## inventory dictionary
var inventory= {
	"farmTile": 20,"waterTile" :2 , "brickTile":0 , "autoFarmTile":0,
	"wheat":10, "corn":0, "bamboo": 0,"berry": 0,"onion": 0, "flower": 0, "pepper": 0
}

## tiles
var currentTile = 0
var placeableTiles = ["farmTile", "waterTile", "brickTile", "autoFarmTile"]

## items
var currentItem = 0
var items = ["hoe", "shovel", "seeds", "hammer"]

## seeds
var currentSeed = 0
var harvestables = ["wheat", "corn", "bamboo", "berry", "onion", "flower", "pepper"]
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
		inventory["berry"] = 9999
		inventory["onion"] = 9999
		inventory["flower"] = 9999
		inventory["pepper"] = 9999
		hotBar.updateAll()
		hud.updateAllCounter()
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
	var ogMode = mode #what mode is before switching to shop
	tileComponent.freeTilePreview()
	var existing_menu = get_node_or_null("ShopMenu")

	if mode == "shop":
		mode = "nothing"
		hotBar.setMode("nothing")
		close_shop_if_open()
	else:
		if existing_menu:
			return
		hotBar.setMode("noseed") #gets rid of seed hud
		mode = "shop"
		
		hotBar.setMode("nothing")
		var shopMenu = shopMenuPreload.instantiate()
		shopMenu.name = "ShopMenu"
		add_child(shopMenu)
		shopMenu.position.y -= 8
		shopMenu.anPlayer.play("open")
		SoundManager.play_ui_sound("res://sounds/book_sound.mp3")
		$Cursor.updateTexture()
		hotBar.setMode("placing")

func reset_to_nothing():
	mode = "nothing"
	tileComponent.freeTilePreview()
	$Cursor.updateTexture()
	hotBar.setMode("nothing")


func close_shop_if_open():
	var existing_menu = get_node_or_null("ShopMenu")
	if existing_menu:
		existing_menu.anPlayer.play("close")
		SoundManager.play_ui_sound("res://sounds/book_close.mp3", 0.3)
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
			for i in range(1, 8):
				if Input.is_action_just_pressed(str(i)):
					currentSeed = i - 1
					hotBar.setTexture("items",2,harvestables[currentSeed])
					hotBar.updateSelected("seeds", currentSeed)
					hotBar.setMode("noseed")
					mode = "farming"
					$Cursor.updateTexture()

func play_walk_sound():
	if $HitBox.isWalkingOnBrick:
		SoundManager.play_sound("res://sounds/brick_walk.mp3",Vector2.ZERO,.4)
	else:
		SoundManager.play_sound("res://sounds/grass_walk.mp3",Vector2.ZERO,.4)
	var particle = dustParticlePreload.instantiate()
	particle.position.y = position.y+8
	particle.position.x = position.x
	particle.get_child(0).emitting = true
	get_parent().get_node("UnderTiles").add_child(particle)
