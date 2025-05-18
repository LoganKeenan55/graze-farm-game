extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("5"):
		print($Tiles.get_children())
		

func _ready() -> void:
	SoundManager.play_sound("res://sounds/music.mp3", Vector2.ZERO, .8) #music - default = .8
