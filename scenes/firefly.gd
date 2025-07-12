extends Node2D


func _ready() -> void:
	$Sprite2D.frame = randi_range(0,3)
	
	z_index = 6
func blink():
	visible = !visible
	

func _on_timer_timeout() -> void:
	blink()
