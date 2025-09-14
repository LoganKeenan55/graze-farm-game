extends Node2D

var maleIntroText = "You scramble your remaining cash together to buy some land on a small island...

You are a city boy and want to impress a kind lady you met at the county fair. You don't know her name but you know she owns the biggest most profitable farm in town.

To impress her you know you have to try starting your own farm, but all you brought was wheat seeds...

She won't be impressed by just a wheat farm and a trailer, so best get to work. "

var femaleIntroText ="You scramble your remaining cash together to buy some land on a small island...

You are a city girl and want to impress a kind man you met at the county fair. You don't know his name but you know he owns the biggest most profitable farm in town.

To impress him you know you have to try starting your own farm, but all you brought was wheat seeds...

he won't be impressed by just a wheat farm and a trailer, so best get to work. "



func setText(str:String):
	$Label.text = str

func _ready() -> void:
	z_index = 51
	if GlobalVars.playerGender == "male":
		$Label.text = maleIntroText
	else:
		$Label.text = femaleIntroText
	animateText()
func animateText():
	var count = 0
	for letter in $Label.text:
		$Label.visible_characters += 1
		await get_tree().create_timer(0.03).timeout

		if count % 3 == 0:
			SoundManager.play_sound("res://sounds/bloop1.mp3",Vector2.ZERO,.4)
			
		count += 1
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("fade")

func _on_continue_button_pressed() -> void:
	get_parent().dirtTransition.removeTiles()
	$AnimationPlayer.play("fadeOut")
	SoundManager.play_music("res://sounds/music.mp3", .8) #music - default = .8
	$Continue/ContinueButton.queue_free()
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeOut":
		queue_free()
		if !GlobalVars.player: #if is in ending scene
			get_parent().sceneAnimationPlayer.play("knock")
			return 
		#if is in main
		GlobalVars.player.set_process(true); GlobalVars.player.set_physics_process(true)
		GlobalVars.globalTime = 8
		
