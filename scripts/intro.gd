extends Node2D

var maleText = "You scramble your remaining cash together to buy some land in the country...

You are a city boy and want to impress a kind mistress you met at the county fair. You don't know her name but you know she owns the biggest most profitable farm in town.

To impress her you know you have to try starting your own farm, but all you brought was wheet seeds...

She won't be impressed by just a wheet farm though so best get to work."

var femaleText ="You scramble your remaining cash together to buy some land in the country...

You are a city girl and want to impress a kind man you met at the county fair. You don't know his name but you know he owns the biggest most profitable farm in town.

To impress him you know you have to try starting your own farm, but all you brought was wheet seeds...

he won't be impressed by just a wheet farm though so best get to work."


func _ready() -> void:
	#GlobalVars.player.set_process(false); GlobalVars.player.set_physics_process(false)
	animateText()
	z_index = 51
	if GlobalVars.playerGender == "male":
		$Label.text = maleText
	else:
		$Label.text = femaleText
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
	
