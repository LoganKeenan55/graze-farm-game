extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("`"):
		Util.quitGame()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
