extends Node2D

var introPreload = preload("res://Intro.tscn")
@onready var dirtTransition = $DirtTransition
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8
	
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
		print(intro)
	else:
		GlobalVars.loadGame() #if the game is not a new game -> load save
		
	dirtTransition.createTiles()

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("d"):
		#GlobalPopUp.createPopUp(self)
		#$MarmotSpawner.spawnMarmot()
