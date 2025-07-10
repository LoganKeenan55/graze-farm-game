extends Node2D

func _ready() -> void:
	#GlobalVars.player.set_process(false); GlobalVars.player.set_physics_process(false)
	animateText()
	z_index = 51
func animateText():
	var count = 0
	for letter in $Label.text:
		$Label.visible_characters += 1
		await get_tree().create_timer(0.03).timeout

		if count % 3 == 0:
			SoundManager.play_sound("res://sounds/bloop1.mp3",Vector2.ZERO,.4)
			
		count += 1
	$AnimationPlayer.play("fade")

func _on_continue_button_pressed() -> void:
	get_parent().dirtTransition.removeTiles()
	$AnimationPlayer.play("fadeOut")
	SoundManager.play_ui_sound("res://sounds/music.mp3", .8) #music - default = .8
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeOut":
		queue_free()
		GlobalVars.player.set_process(true); GlobalVars.player.set_physics_process(true)
	
