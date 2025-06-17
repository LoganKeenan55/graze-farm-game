extends Node2D
class_name HUD
@onready var player:Player = self.get_parent()



func _ready() -> void:
	setSizeBasedOnUpgradeLevel()
	z_index = 10
	$NightTimeFilter.z_index = 5
	GlobalFarmTileManager.connect("night_started", Callable(self, "setNight"))
	GlobalFarmTileManager.connect("day_started", Callable(self, "setDay"))
	$Control/VBoxContainer/WheatContainer/Count.text = str(player.inventory["wheat"])
	$Control/VBoxContainer/CornContainer/Count.text = str(player.inventory["corn"])
	$Control/VBoxContainer/BambooContainer/Count.text = str(player.inventory["bamboo"])
	$Control/VBoxContainer/BerryContainer/Count.text = str(player.inventory["berry"])
	$Control/VBoxContainer/OnionContainer/Count.text = str(player.inventory["onion"])
	$Control/VBoxContainer/FlowerContainer/Count.text = str(player.inventory["flower"])
	$Control/VBoxContainer/PepperContainer/Count.text = str(player.inventory["pepper"])
	await get_tree().create_timer(0.1).timeout
	updateAllCounterWithoutAnimation()

func setSizeBasedOnUpgradeLevel():
	match player.unlockLevel:
		1:
			$Control/background1.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
		2:
			$Control/background1.visible = false
			$Control/background2.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
		3:
			$Control/background2.visible = false
			$Control/background3.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$Control/VBoxContainer/FlowerContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
			$HotBar.seedBar.setSpecificTexture(3,player.harvestables[0])
		4:
			$Control/background3.visible = false
			$Control/background4.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$Control/VBoxContainer/FlowerContainer.visible = true
			$Control/VBoxContainer/PepperContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
			$HotBar.seedBar.setSpecificTexture(3,player.harvestables[3])
			$HotBar.seedBar.setSpecificTexture(4,player.harvestables[4])
		5:
			$Control/background4.visible = false
			$Control/background5.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$Control/VBoxContainer/FlowerContainer.visible = true
			$Control/VBoxContainer/PepperContainer.visible = true
			$Control/VBoxContainer/CornContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
			$HotBar.seedBar.setSpecificTexture(3,player.harvestables[3])
			$HotBar.seedBar.setSpecificTexture(4,player.harvestables[4])
			$HotBar.seedBar.setSpecificTexture(5,player.harvestables[5])
		6:
			$Control/background5.visible = false
			$Control/background6.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$Control/VBoxContainer/FlowerContainer.visible = true
			$Control/VBoxContainer/PepperContainer.visible = true
			$Control/VBoxContainer/CornContainer.visible = true
			$Control/VBoxContainer/BerryContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
			$HotBar.seedBar.setSpecificTexture(3,player.harvestables[3])
			$HotBar.seedBar.setSpecificTexture(4,player.harvestables[4])
			$HotBar.seedBar.setSpecificTexture(5,player.harvestables[5])
			$HotBar.seedBar.setSpecificTexture(6,player.harvestables[6])
		7:
			$Control/background6.visible = false
			$Control/background7.visible = true
			$Control/VBoxContainer/WheatContainer.visible = true
			$Control/VBoxContainer/BambooContainer.visible = true
			$Control/VBoxContainer/FlowerContainer.visible = true
			$Control/VBoxContainer/PepperContainer.visible = true
			$Control/VBoxContainer/CornContainer.visible = true
			$Control/VBoxContainer/BerryContainer.visible = true
			$Control/VBoxContainer/OnionContainer.visible = true
			$HotBar.seedBar.setSpecificTexture(0,player.harvestables[0])
			$HotBar.seedBar.setSpecificTexture(1,player.harvestables[1])
			$HotBar.seedBar.setSpecificTexture(3,player.harvestables[3])
			$HotBar.seedBar.setSpecificTexture(4,player.harvestables[4])
			$HotBar.seedBar.setSpecificTexture(5,player.harvestables[5])
			$HotBar.seedBar.setSpecificTexture(6,player.harvestables[6])
			$HotBar.seedBar.setSpecificTexture(7,player.harvestables[7])
func updateAllCounterWithoutAnimation():
	$Control/VBoxContainer/WheatContainer/Count.text = str(player.inventory["wheat"])
	$Control/VBoxContainer/CornContainer/Count.text = str(player.inventory["corn"])
	$Control/VBoxContainer/BambooContainer/Count.text = str(player.inventory["bamboo"])
	$Control/VBoxContainer/BerryContainer/Count.text = str(player.inventory["berry"])
	$Control/VBoxContainer/OnionContainer/Count.text = str(player.inventory["onion"])
	$Control/VBoxContainer/FlowerContainer/Count.text = str(player.inventory["flower"])
	$Control/VBoxContainer/PepperContainer/Count.text = str(player.inventory["pepper"])

func _process(_delta: float) -> void:
	$time.text = str(GlobalVars.globalTime)
	$ClockSprite/handSprite.rotation = (GlobalVars.globalTime / 12.0) * TAU

func setNight():
	SoundManager.play_ui_sound("res://sounds/turn_night.mp3",.45)
	$NightTimeFilter/NightFilterAnimationPlayer.play("turn_night")

func setDay():
	SoundManager.play_ui_sound("res://sounds/turn_day.mp3",.45)
	$NightTimeFilter/NightFilterAnimationPlayer.play("turn_day")

func updateAllCounter():
	$Control/VBoxContainer/WheatContainer/Count.text = str(player.inventory["wheat"])
	$Control/VBoxContainer/WheatContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/WheatContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/CornContainer/Count.text = str(player.inventory["corn"])
	$Control/VBoxContainer/CornContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/CornContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/BambooContainer/Count.text = str(player.inventory["bamboo"])
	$Control/VBoxContainer/BambooContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/BambooContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/BerryContainer/Count.text = str(player.inventory["berry"])
	$Control/VBoxContainer/BerryContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/BerryContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/OnionContainer/Count.text = str(player.inventory["onion"])
	$Control/VBoxContainer/OnionContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/OnionContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/FlowerContainer/Count.text = str(player.inventory["flower"])
	$Control/VBoxContainer/FlowerContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/FlowerContainer/AnimationPlayer.play("update")
	$Control/VBoxContainer/PepperContainer/Count.text = str(player.inventory["pepper"])
	$Control/VBoxContainer/PepperContainer/AnimationPlayer.stop()
	$Control/VBoxContainer/PepperContainer/AnimationPlayer.play("update")

	
func updateCounter(cropType: String):
	match cropType:
		"wheat":
			$Control/VBoxContainer/WheatContainer/Count.text = str(player.inventory["wheat"])
			$Control/VBoxContainer/WheatContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/WheatContainer/AnimationPlayer.play("update")
		"corn":
			$Control/VBoxContainer/CornContainer/Count.text = str(player.inventory["corn"])
			$Control/VBoxContainer/CornContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/CornContainer/AnimationPlayer.play("update")
		"bamboo":
			$Control/VBoxContainer/BambooContainer/Count.text = str(player.inventory["bamboo"])
			$Control/VBoxContainer/BambooContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/BambooContainer/AnimationPlayer.play("update")
		"berry":
			$Control/VBoxContainer/BerryContainer/Count.text = str(player.inventory["berry"])
			$Control/VBoxContainer/BerryContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/BerryContainer/AnimationPlayer.play("update")
		"onion":
			$Control/VBoxContainer/OnionContainer/Count.text = str(player.inventory["onion"])
			$Control/VBoxContainer/OnionContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/OnionContainer/AnimationPlayer.play("update")
		"flower":
			$Control/VBoxContainer/FlowerContainer/Count.text = str(player.inventory["flower"])
			$Control/VBoxContainer/FlowerContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/FlowerContainer/AnimationPlayer.play("update")
		"pepper":
			$Control/VBoxContainer/PepperContainer/Count.text = str(player.inventory["pepper"])
			$Control/VBoxContainer/PepperContainer/AnimationPlayer.stop()
			$Control/VBoxContainer/PepperContainer/AnimationPlayer.play("update")
		
