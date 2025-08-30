extends Node2D
class_name Shop

var prices = {
	"farmTile": {"wheat": 5},
	"waterTile" :{"bamboo": 10},
	"brickTile":{"flower": 3},
	"autoFarmTile":{"corn": 20},
	"bamboo":{"wheat": 25},
	"flower":{"bamboo":40},
	"corn":{"flower": 30},
	"berry":{"corn": 25},
	"onion":{"berry": 50},
}

@onready var anPlayer = $AnimationPlayer

func _ready() -> void:
	z_index = 20
	setDefaultPrices()
	checkUnlockLevel()
	setSliders()
func checkUnlockLevel():
	if !GlobalVars.player:
		return
	match GlobalVars.player.unlockLevel:
		1:
			$Shop/VBoxContainer2/HBoxContainer2/FlowerLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer2/BambooRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer3/CornLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer3/FlowerRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer4/BerryLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer4/CornRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/OnionLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/BerryRight.texture.region = Rect2(80, 0, 16, 16)
		2:
			$Shop/VBoxContainer2/HBoxContainer3/CornLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer3/FlowerRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer4/BerryLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer4/CornRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/OnionLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/BerryRight.texture.region = Rect2(80, 0, 16, 16)
		3:
			
			$Shop/VBoxContainer2/HBoxContainer4/BerryLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer4/CornRight.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/OnionLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/BerryRight.texture.region = Rect2(80, 0, 16, 16)
		4:
			$Shop/VBoxContainer2/HBoxContainer3/CornLeft.texture.region = GlobalVars.textureRegions["corn"]
			$Shop/VBoxContainer2/HBoxContainer3/FlowerRight.texture.region = GlobalVars.textureRegions["flower"]
			$Shop/VBoxContainer2/HBoxContainer5/OnionLeft.texture.region = Rect2(80, 0, 16, 16)
			$Shop/VBoxContainer2/HBoxContainer5/BerryRight.texture.region = Rect2(80, 0, 16, 16)
		5:
			pass

func setSliders() -> void:
	$Shop/Settigs/Node2D/GameVolume.value = SoundManager.volume * 100
	$Shop/Settigs/Node2D/MusicVolume.value = SoundManager.musicVolume * 100
func setDefaultPrices():
	$Shop/VBoxContainer/HBoxContainer/FarmTilePrice.text = str(prices["farmTile"].values()[0])
	$Shop/VBoxContainer/HBoxContainer2/WaterTilePrice.text = str(prices["waterTile"].values()[0])
	$Shop/VBoxContainer/HBoxContainer3/BrickTilePrice.text = str(prices["brickTile"].values()[0])
	$Shop/VBoxContainer/HBoxContainer4/AutoFarmTilePrice.text = str(prices["autoFarmTile"].values()[0])
	
	#$Control2/VBoxContainer2/HBoxContainer/WheatPrice.text = str(prices["wheat"].values()[0])
	$Shop/VBoxContainer2/HBoxContainer3/CornPrice.text = str(prices["corn"].values()[0])
	$Shop/VBoxContainer2/HBoxContainer/BambooPrice.text = str(prices["bamboo"].values()[0])
	$Shop/VBoxContainer2/HBoxContainer4/BerryPrice.text = str(prices["berry"].values()[0])
	$Shop/VBoxContainer2/HBoxContainer5/OnionPrice.text = str(prices["onion"].values()[0])
	$Shop/VBoxContainer2/HBoxContainer2/FlowerPrice.text =  str(prices["flower"].values()[0])
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		queue_free()
		
func _on_farm_tile_button_pressed() -> void: 
	buy("wheat","farmTile")
	
func _on_water_tile_button_pressed() -> void:
	buy("bamboo","waterTile")


func _on_brick_tile_button_pressed() -> void:
	buy("flower","brickTile")


func _on_auto_farm_tile_button_pressed() -> void:
	if !GlobalVars.autoFarmTileUnlocked:
		GlobalVars.autoFarmTileUnlocked = true
		Util.createPopUp("AutoTile unlocked, place and seed to auto harvest crops. Hammer to upgrade", 3, .4)
	buy("corn","autoFarmTile")
	
func buy(itemGive:String, itemGet:String):
	
	var inventory = GlobalVars.player.inventory
	var amount = prices[itemGet].values()[0]
	if (inventory[itemGive]-amount) >= 0:
		GlobalVars.player.recieve(itemGet,1)
		GlobalVars.player.recieve(itemGive,-amount)
		

		SoundManager.play_ui_sound("res://sounds/purchase.mp3")

		if itemGet == "bamboo":
			$Shop/VBoxContainer2/HBoxContainer2/FlowerLeft.texture.region = GlobalVars.textureRegions["flower"]
			$Shop/VBoxContainer2/HBoxContainer2/BambooRight.texture.region = GlobalVars.textureRegions["bamboo"]
		if itemGet == "corn":
			$Shop/VBoxContainer2/HBoxContainer4/BerryLeft.texture.region = GlobalVars.textureRegions["berry"]
			$Shop/VBoxContainer2/HBoxContainer4/CornRight.texture.region = GlobalVars.textureRegions["corn"]
		if itemGet == "berry":
		
			$Shop/VBoxContainer2/HBoxContainer5/OnionLeft.texture.region = GlobalVars.textureRegions["onion"]
			$Shop/VBoxContainer2/HBoxContainer5/BerryRight.texture.region = GlobalVars.textureRegions["berry"]
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")
		return false
	

func _on_corn_button_pressed() -> void:
	if GlobalVars.player.unlockLevel >= 4:
		buy("flower","corn")
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")
		
func _on_bamboo_button_pressed() -> void:
	buy("wheat","bamboo")
	

func _on_berry_button_pressed() -> void:
	if GlobalVars.player.unlockLevel >= 5:
		buy("corn","berry")
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")

func _on_onion_button_pressed() -> void:
	if GlobalVars.player.unlockLevel >= 6:
		buy("berry","onion")
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")

func _on_flower_button_pressed() -> void:
	if GlobalVars.player.unlockLevel >= 2:
		buy("bamboo","flower")
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")

func switchMode(type:String):
	if type == "shop":
		$Shop/Settigs.visible = false
		$Shop/InfoTab.visible = true
	if type == "settings":
		$Shop/Settigs.visible = true
		$Shop/InfoTab.visible = false
	SoundManager.play_ui_sound("res://sounds/book_sound.mp3")


func _on_shop_button_pressed() -> void:
	switchMode("shop")
	

func _on_settings_button_pressed() -> void:
	switchMode("settings")


func _on_save_button_pressed() -> void:
	GlobalVars.saveGame()


func _on_quit_button_pressed() -> void:
	if GlobalVars.autoSave:
		GlobalVars.saveGame()
	get_tree().quit()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_game_volume_value_changed(value: float) -> void:
	SoundManager.volume = value / 100

func _on_music_volume_value_changed(value: float) -> void:
	
	SoundManager.musicVolume = value / 100
	var busIndex = AudioServer.get_bus_index("Music")
	var db = linear_to_db(value / 100.0)  # convert normalized volume to dB
	AudioServer.set_bus_volume_db(busIndex, db)
	
