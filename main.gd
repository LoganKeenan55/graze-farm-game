extends Node2D


func _ready() -> void:
	#SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8
	
	### SET GLOBAL VARS
	GlobalVars.player = $Player
	GlobalVars.tilesParent = $Tiles
	GlobalVars.underTilesParent = $UnderTiles
	SoundManager.player = $Player
	### SET GLOBAL VARS
	
	if !GlobalVars.isNewGame: #if the game is not a new game -> load save
		GlobalVars.loadGame()
	#print(DirtTransition.posArr)
	$DirtTransition.openTransition()
	#$DirtTransition.position = $Player.position# - Vector2(140,100)
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("d"):
		#$MarmotSpawner.spawnMarmot()
