extends Area2D


@onready var player = get_tree().current_scene.find_child("Player", true, false)
var removeParticlePreload = preload("res://autoFarmerParticle.tscn")

func _ready():
	set_process_input(true)

func handleDeletingTile(event):
	
	if Input.is_action_pressed("left_click"):
		set_process_input(false)
		createRemoveParticle()
		player.inventory["autoFarmTile"]+=1 
		print(player.inventory["autoFarmTile"])
		player.hotBar.setAmount("tiles",player.placeableTiles.find("autoFarmTile"),player.inventory["autoFarmTile"])
		get_parent().queue_free()  # Delete the object
		queue_free()

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			pass
		"shovel":
			handleDeletingTile(event)
		"seeds":
			pass
				
func createRemoveParticle():
	var particle = removeParticlePreload.instantiate()
	particle.position = get_parent().position
	particle.get_child(0).emitting = true
	get_parent().get_parent().get_parent().add_child(particle)



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player and player.mode == "farming":
		handlePlayerInterection(event)
