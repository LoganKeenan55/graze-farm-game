extends Node2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SoundManager.player = self
func _on_continue_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop7.mp3")


func _on_new_game_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop2.mp3")


func _on_quit_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop1.mp3")


func _on_continue_button_pressed() -> void:
	GlobalVars.isNewGame = false
	get_tree().change_scene_to_file("res://main.tscn")
	


func _on_new_game_button_pressed() -> void:
	GlobalVars.isNewGame = true
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
