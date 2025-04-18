extends Area2D

func _process(_delta: float) -> void:
	handleWalkingOnBrickTiles()

func handleWalkingOnBrickTiles():
	var overlapping = get_overlapping_areas()

	for area in overlapping:
		if area.get_parent().is_in_group("brickTiles"):
			
			get_parent().speed = 130
			return

	get_parent().speed = 96
	#dprint("decrease!")
