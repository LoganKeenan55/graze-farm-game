extends Node2D

func _ready() -> void:
	GlobalVars.player.set_process(false); GlobalVars.player.set_physics_process(false)
	
