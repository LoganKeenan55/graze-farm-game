extends Sprite2D



func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position() -  Vector2(158,90)

func pickRandomSeed() -> String:
	var randInt = randi_range(0,6)
	match randInt:
		0:
			return "wheat"
		1:
			return "corn"
		2:
			return "bamboo"
		3:
			return "berry"
		4:
			return "onion"
		5:
			return "flower"
		6:
			return "pepper"
			
	return "dafuq"
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if get_parent().transitioning == true:
		return
	var parent = area.get_parent()
	if parent.tileType != "farmTile":
		return
	if parent.stateIndex ==4 :
		SoundManager.play_sound("res://sounds/harvest_sound.mp3", parent.position)
		parent.createHarvestParticle()
		parent.stateIndex = 1
		parent.updateTexture()
		return
	if parent.stateIndex <2:
		SoundManager.play_sound("res://sounds/seed_sound.mp3", parent.position)
		parent.setType(pickRandomSeed())
		parent.stateIndex = 2
		parent.updateTexture()
