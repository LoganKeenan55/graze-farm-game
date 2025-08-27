extends Area2D
##
@onready var player: Player = get_tree().current_scene.find_child("Player", true, false)
@onready var upgrateToolTipPreload = preload("res://scenes/upgradeToolTip.tscn")

##
var tooltip: ToolTip = null
var removeParticlePreload
var deleted = false

func _ready():
	set_process_input(true)
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func handleDeletingTile(): #shovel
	if deleted:
		return
	if Input.is_action_pressed("left_click"):
		set_process_input(false)
		createRemoveParticle()
	#	player.inventory[get_parent().tileType]+=1 
		player.recieve(get_parent().tileType,1)
		player.hotBar.setAmount("tiles",player.placeableTiles.find(get_parent().tileType),player.inventory[get_parent().tileType])
		get_parent().queue_free()  #delete the object
		deleted = true
		SoundManager.play_sound(get_parent().sound)
			
		match get_parent().tileType: #tile specific code for deleting
			"waterTile":
				get_parent().updateFertileTiles(-1)
			"farmTile":
				if get_parent().stateIndex >= 2 and get_parent().stateIndex <= 3:
					#player.inventory[get_parent().cropType] += 1
					player.recieve(get_parent().cropType, 1)
					#player.hud.updateCounter(get_parent().cropType)
				if get_parent().stateIndex == 4:
					get_parent().harvestCrop()
			"autoFarmTile":
				if get_parent().cropType != "default":
					#player.inventory[get_parent().cropType] += get_parent().priceCounts[get_parent().cropType] #"refund" whatever is put in
					player.recieve(get_parent().cropType, get_parent().priceCounts[get_parent().cropType])
					player.hotBar.updateAll()
			"brickTile":
				pass
			_:
				print("INVALID TYPE in function: handleDeletingTile")
		player.hotBar.updateAmounts("seeds")
				
		
func handleHarvesting():
	if get_parent().cropType == "pepper":
		#always require a click for peppers
		if Input.is_action_pressed("click") and get_parent().tileState[get_parent().stateIndex] == "harvestable":
			get_parent().harvestCrop()
	elif GlobalVars.farmOnClick:
		#require a click
		if Input.is_action_pressed("click") and get_parent().tileState[get_parent().stateIndex] == "harvestable":
			get_parent().harvestCrop()
	else:
		if get_parent().tileState[get_parent().stateIndex] == "harvestable":
			get_parent().harvestCrop()

		
#	if abs(Input.get_last_mouse_velocity().x) + abs(Input.get_last_mouse_velocity().y) >1000:
	#use ^? only harvests if mouse is at certain speed
	
var can_click := true
func handleHammer():
	if not can_click:
		return
	match get_parent().tileType:
		"waterTile":
			pass
		"autoFarmTile":
			if tooltip == null and get_parent().cropType != "default":
				tooltip = upgrateToolTipPreload.instantiate()
				get_parent().add_child(tooltip)
	
				tooltip.position = position
				tooltip.z_index = 12
				
				if get_parent().level <= 3: #not max level
					tooltip.setToolTip("berry","Upgrade?",str(get_parent().upgradePrices[get_parent().cropType]))
				
				if get_parent().level >= 4: #max level
					tooltip.setToolTip("default","Max Level","")
					tooltip.colorRect.visible = false
					tooltip.position.y += 10
			
			if Input.is_action_just_pressed("left_click"):
				if get_parent().cropType == "default":
					return

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
				
				get_parent().upgrade()
				get_parent().updateTexture()
				tooltip.queue_free()
				player.hotBar.updateAll()
		"farmTile":
			if tooltip == null and get_parent().stateIndex >= 2:
				tooltip = upgrateToolTipPreload.instantiate()
				get_parent().add_child(tooltip)
				tooltip.position = position
				tooltip.z_index = 12
				tooltip.setToolTip(get_parent().cropType,"Uproot?",str(1))

			if Input.is_action_just_pressed("left_click"):
				if tooltip == null:
					return
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
				get_parent().stateIndex = 1
				get_parent().updateTexture()
				player.inventory[get_parent().cropType]+=1
				get_parent().createHarvestParticle()
				player.hotBar.updateAll()
				player.hud.updateCounter(get_parent().cropType)
				tooltip.queue_free()
		"brickTile":
			pass
		_:
			print("INVALID TYPE in function: handleHammer")
		
func _on_mouse_exited():
	if tooltip:
		tooltip.queue_free()
		tooltip = null
	

func handleSeeding(): #seed
	match get_parent().tileType:
		"farmTile":
			if get_parent().tileState[get_parent().stateIndex] == "fertile" and Input.is_action_pressed("left_click"):
				get_parent().seedCrop(player.harvestables[player.currentSeed])
				#player.hud.updateCounter(get_parent().cropType)
		"autoFarmTile":
			if get_parent().cropType != "default": #check if autoFarmTile hasn't already been seeded
				return 
			if tooltip == null: #create tooltip
				tooltip = upgrateToolTipPreload.instantiate()
				get_parent().add_child(tooltip)
				tooltip.changeCropType(get_parent().cropType)
				tooltip.position = position
				tooltip.z_index = 12
				
				tooltip.setToolTip(player.harvestables[player.currentSeed],"Seed?",str(get_parent().seedPrices[player.harvestables[player.currentSeed]]))
			
			if  Input.is_action_pressed("left_click"): #seed autoFarmTile
				get_parent().setCrop(player.harvestables[player.currentSeed])
				if get_parent().cropType != "default":
					tooltip.queue_free()
		_:
			print("INVALID TYPE in function: handleSeeding")
func createRemoveParticle():
	var particle = removeParticlePreload.instantiate()
	particle.position = get_parent().position
	particle.get_child(0).emitting = true
	
	if get_parent().get_parent().get_parent().get_parent():
		get_parent().get_parent().get_parent().get_parent().add_child(particle)


func handlePlayerInterection(event): #needed for all tiles
	#match player.items[player.currentItem]:
		#"hoe":
			#
			#pass
		#"shovel":
			#pass
		#"seeds":
	pass
				

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player:
		if player.mode == "farming" or player.mode == "seed":
			handlePlayerInterection(event)
