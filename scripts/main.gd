extends Node2D

var introPreload = preload("res://scenes/Intro.tscn")
@onready var dirtTransition = $DirtTransition
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	### SET GLOBAL VARS
	GlobalVars.player = $YSort/Player
	GlobalVars.tilesParent = $YSort/Tiles
	GlobalVars.underTilesParent = $UnderTiles
	SoundManager.player = $YSort/Player
	### SET GLOBAL VARS
	
	if GlobalVars.isNewGame: #if the game is a new game -> tutorial
		var intro = introPreload.instantiate()
		add_child(intro)
		intro.position = $YSort/Player.global_position
		setPepper()
		dirtTransition.createTiles()
		GlobalVars.player.set_process(false); GlobalVars.player.set_physics_process(false)
		
	else:
		GlobalVars.loadGame() #if the game is not a new game -> load save
		dirtTransition.openTransition()
		SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8

#func _process(delta: float) -> void:
	
	#if Input.is_action_just_pressed("d"):
		#GlobalPopUp.createPopUp(self)
		#$MarmotSpawner.spawnMarmot()

func setPepper():
	$YSort/Tiles/pepper.setType("pepper")
	$YSort/Tiles/pepper.stateIndex = 4
	$YSort/Tiles/pepper.updateTexture()
