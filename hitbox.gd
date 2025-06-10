extends Area2D

func _ready() -> void:
	set_process_input(true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	handlePlayerInteraction(event)

func handlePlayerInteraction(event):
	if get_parent().isLeaving == false:
		get_parent().leave("leave_scared")
