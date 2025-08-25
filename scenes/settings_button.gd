extends Node2D

@export var text = ""

func _ready() -> void:
	$Text.text = text
	if text == "Fullscreen":
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			setOnOff(true)
		else:
			setOnOff(false)
	#if text == "auto save"
func _on_button_pressed() -> void:
	if text == "Fullscreen":
		setOnOff(DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func setOnOff(OnOff: bool):
	if text == "Fullscreen":
		if OnOff == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
