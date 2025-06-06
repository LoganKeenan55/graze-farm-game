extends Node2D


func _ready() -> void:
	SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
