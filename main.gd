extends Node2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8
	
	### SET GLOBAL VARS
	GlobalVars.player = $YSort/Player
	GlobalVars.tilesParent = $YSort/Tiles
	GlobalVars.underTilesParent = $UnderTiles
	SoundManager.player = $YSort/Player
	### SET GLOBAL VARS
	
	if !GlobalVars.isNewGame: #if the game is not a new game -> load save
		GlobalVars.loadGame()

	$DirtTransition.openTransition()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("d"):
		$MarmotSpawner.spawnMarmot()
