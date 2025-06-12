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
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("t"):
		doTransition()

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("d"):
		#$MarmotSpawner.spawnMarmot()

func doTransition() -> void:
	var tiles = $Tiles.get_children()
	for i in range(tiles.size() - 1, -1, -1):  # from last index to 0
		var tile = tiles[i]
		tile.hitbox.createRemoveParticle()
		tile.queue_free()  # delete the object
		SoundManager.play_sound(tile.sound)
		await get_tree().create_timer(0.1).timeout
