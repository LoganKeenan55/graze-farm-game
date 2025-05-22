extends Node2D

@onready var anPlayer = $AnimationPlayer
func _ready() -> void:
	z_index = 20


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		queue_free()
		print("yay")
