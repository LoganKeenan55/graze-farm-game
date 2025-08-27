extends Node2D
class_name PopUp

@onready var animPlayer = $AnimationPlayer

func _ready() -> void:
	if self != null:
		$AnimationPlayer.play("transition")
		z_index = 30
func setText(text:String):
	$ColorRect/Label.text = text
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
