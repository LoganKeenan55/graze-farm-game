extends Area2D

var removeParticlePreload = preload("res://RemoveParticle.tscn")
@onready var player = get_tree().current_scene.find_child("Player", true, false)

func _ready():
	set_process_input(true)
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player and player.mode == "farming":
		handlePlayerInterection(event)


func handleDeletingTile(event):
	if Input.is_action_pressed("left_click"):
		handleHarvesting()
		createRemoveParticle()
		#print(get_parent())
		get_parent().queue_free()  #delete the object

func handleHarvesting():
	if get_parent().tileState[get_parent().stateIndex] == "harvestable":
		get_parent().harvestCrop()
#	if abs(Input.get_last_mouse_velocity().x) + abs(Input.get_last_mouse_velocity().y) >1000:
func handleSeeding():
	if get_parent().tileState[get_parent().stateIndex] == "fertile" and Input.is_action_pressed("left_click"):
		if player.harvestables[player.currentSeed] == "wheat":
			get_parent().seedCrop("wheat")
		if player.harvestables[player.currentSeed] == "corn":
			get_parent().seedCrop("corn")


func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			handleHarvesting()
		"shovel":
			handleDeletingTile(event)
		"seeds":
			handleSeeding()


func createRemoveParticle():
	var particle = removeParticlePreload.instantiate()
	particle.position = get_parent().position
	particle.get_child(0).emitting = true
	particle.add_to_group("remove")
	get_parent().get_parent().get_parent().add_child(particle)
	await get_tree().create_timer(1).timeout
	particle.queue_free()
