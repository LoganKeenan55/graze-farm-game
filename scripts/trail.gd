extends Line2D
var queue: Array
var maxLength: int = 10


func _ready() -> void:
	z_index = 12
	visible = false
func _process(_delta: float) -> void:
	var pos = get_viewport().get_mouse_position() -  Vector2(158,95)

	queue.push_front(pos)
	
	if queue.size() > maxLength:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		if abs(Input.get_last_mouse_velocity().x)+abs(Input.get_last_mouse_velocity().y) > 3000:
			add_point(point)


	if get_parent().currentItem == 0 and get_parent().mode == "farming":
		visible = true
	else:
		visible = false
