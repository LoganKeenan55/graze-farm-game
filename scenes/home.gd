extends Node2D
var can_click := true

@onready var upgrateToolTipPreload = preload("res://scenes/upgradeToolTip.tscn")


var tooltip: ToolTip = null

func upgrade():
	pass

func handleHammer():
	if not can_click:
		return
	
	if tooltip == null:
		tooltip = upgrateToolTipPreload.instantiate()
		get_parent().add_child(tooltip)
	
		tooltip.position = position
		tooltip.z_index = 12
				
				
		tooltip.setToolTip("berry","Upgrade?","berry")
				
				
		if Input.is_action_just_pressed("left_click"):
			upgrade()

			################# timer to prevent bug of upgrading too many times on one click
			can_click = false
			var cooldown_timer = Timer.new()
			cooldown_timer.wait_time = 0.2
			cooldown_timer.one_shot = true
			add_child(cooldown_timer)
			cooldown_timer.start()
			cooldown_timer.timeout.connect(func():
				can_click = true
				cooldown_timer.queue_free()
			)
			################
					
	
			tooltip.queue_free()

	
func _on_mouse_exited():
	if tooltip:
		tooltip.queue_free()
		tooltip = null


func handlePlayerInterection(event):
	match GlobalVars.player.items[GlobalVars.player.currentItem]:
		"hoe":
			pass
		"shovel":
			pass
		"seeds":
			pass
		"hammer":
			handleHammer()

		


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if GlobalVars.player:
			if GlobalVars.player.mode == "farming":
				handlePlayerInterection(event)
