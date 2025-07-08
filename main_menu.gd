extends Node2D

var transitioning = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
	SoundManager.player = self
	await get_tree().create_timer(.3).timeout
	$MainMenuCursor/Area2D.monitoring = true
func _on_continue_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop7.mp3")
	

func _on_new_game_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop2.mp3")
	

func _on_quit_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("res://sounds/bloop1.mp3")


func _on_continue_button_pressed() -> void:
	GlobalVars.isNewGame = false
	$DirtTransition.closeTransition()
	transitioning = true
	$MenuMusic/AnimationPlayer.play("exit")
	


func _on_new_game_button_pressed() -> void:
	GlobalVars.isNewGame = true
	transitioning = true
	$DirtTransition.closeTransition()
	$MenuMusic/AnimationPlayer.play("exit")
func _on_quit_button_pressed() -> void:
	get_tree().quit()
