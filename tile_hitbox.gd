extends Area2D

@onready var player = get_tree().current_scene.find_child("Player", true, false)
@onready var upgrateToolTipPreload = preload("res://upgradeToolTip.tscn")

var tooltip: Node = null
var removeParticlePreload
var deleted = false

func _ready():
	set_process_input(true)
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func handleDeletingTile(event):
	if !deleted:
		if Input.is_action_pressed("left_click"):
			set_process_input(false)
			createRemoveParticle()
			player.inventory[get_parent().tileType]+=1 
			player.hotBar.setAmount("tiles",player.placeableTiles.find(get_parent().tileType),player.inventory[get_parent().tileType])
			get_parent().queue_free()  # Delete the object
			deleted = true
			SoundManager.play_sound(get_parent().sound)
			
			match get_parent().tileType: #Tile specific code for deleting
				"waterTile":
					get_parent().updateFertileTiles(-1)
				"farmTile":
					if get_parent().stateIndex >= 2 and get_parent().stateIndex <= 3:
						player.inventory[get_parent().cropType] += 1
					if get_parent().stateIndex == 4:
						get_parent().harvestCrop()
			player.hotBar.updateAmounts("seeds")
				
				
func handleHarvesting():
	if get_parent().tileState[get_parent().stateIndex] == "harvestable":
		get_parent().harvestCrop()
#	if abs(Input.get_last_mouse_velocity().x) + abs(Input.get_last_mouse_velocity().y) >1000:

func handleHammer():
	if tooltip == null: #create tooltip
		tooltip = upgrateToolTipPreload.instantiate()
		get_parent().add_child(tooltip)
		tooltip.position = position
	
	if Input.is_action_pressed("left_click"): #if left click
		get_parent().stateIndex+=1
		get_parent().updateTexture()


func _on_mouse_exited():
	if tooltip:
		tooltip.queue_free()
		tooltip = null


func handleSeeding():
	match get_parent().tileType:
		"farmTile":
			if get_parent().tileState[get_parent().stateIndex] == "fertile" and Input.is_action_pressed("left_click"):
				if player.harvestables[player.currentSeed] == "wheat":
					get_parent().seedCrop("wheat")
				if player.harvestables[player.currentSeed] == "corn":
					get_parent().seedCrop("corn")
		"autoFarmTile":
			if Input.is_action_pressed("left_click"):
				print("seeded")

func handlePlayerInterection(event):
	#match player.items[player.currentItem]:
		#"hoe":
			#
			#pass
		#"shovel":
			#pass
		#"seeds":
	pass
				
func createRemoveParticle():
	var particle = removeParticlePreload.instantiate()
	particle.position = get_parent().position
	particle.get_child(0).emitting = true
	get_parent().get_parent().get_parent().add_child(particle)



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player and player.mode == "farming":
		handlePlayerInterection(event)
