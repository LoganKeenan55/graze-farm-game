extends Node2D

var prices = {
	"farmTile": {"wheat": 5},
	"waterTile" :{"corn": 15},
	"brickTile":{"bamboo": 20},
	"autoFarmTile":{"berry": 50},
	"wheat":{"corn": 50},
	"corn":{"wheat": 50},
	"bamboo":{"corn": 50},
	"berry":{"bamboo": 50},
	"onion":{"berry": 50},
}

@onready var anPlayer = $AnimationPlayer

func _ready() -> void:
	z_index = 20
	setDefaultPrices()

func setDefaultPrices():
	$Control2/VBoxContainer/HBoxContainer/FarmTilePrice.text = str(prices["farmTile"].values()[0])
	$Control2/VBoxContainer/HBoxContainer2/WaterTilePrice.text = str(prices["waterTile"].values()[0])
	$Control2/VBoxContainer/HBoxContainer3/BrickTilePrice.text = str(prices["brickTile"].values()[0])
	$Control2/VBoxContainer/HBoxContainer4/AutoFarmTilePrice.text = str(prices["autoFarmTile"].values()[0])
	
	$Control2/VBoxContainer2/HBoxContainer/WheatPrice.text = str(prices["wheat"].values()[0])
	$Control2/VBoxContainer2/HBoxContainer2/CornPrice.text = str(prices["corn"].values()[0])
	$Control2/VBoxContainer2/HBoxContainer3/BambooPrice.text = str(prices["bamboo"].values()[0])
	$Control2/VBoxContainer2/HBoxContainer4/BerryPrice.text = str(prices["berry"].values()[0])
	$Control2/VBoxContainer2/HBoxContainer5/OnionPrice.text = str(prices["onion"].values()[0])
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		queue_free()

func _on_farm_tile_button_pressed() -> void: 
	buy("wheat",prices["farmTile"].values()[0],"farmTile")
	
func _on_water_tile_button_pressed() -> void:
	buy("corn",prices["waterTile"].values()[0],"waterTile")


func _on_brick_tile_button_pressed() -> void:
	buy("bamboo",prices["brickTile"].values()[0],"brickTile")


func _on_auto_farm_tile_button_pressed() -> void:
	buy("berry",prices["autoFarmTile"].values()[0],"autoFarmTile")

func buy(cropType:String, amount:int, purchase:String):
	var inventory = GlobalVars.player.inventory
	if (inventory[cropType]-amount) >= 0:
		inventory[cropType] = inventory[cropType] - amount
		inventory[purchase] = inventory[purchase] + 1
		SoundManager.play_ui_sound("res://sounds/purchase.mp3")
		#hotBar.setAmount("tiles",placeableTiles.find(type),inventory[type])
		GlobalVars.player.hotBar.updateAll()
		GlobalVars.player.hud.updateCounter(cropType)
	else:
		SoundManager.play_ui_sound("res://sounds/not_enough.mp3")
		return false
	

func _on_corn_button_pressed() -> void:
	buy("wheat",prices["corn"].values()[0],"corn")


func _on_bamboo_button_pressed() -> void:
	buy("corn",prices["bamboo"].values()[0],"bamboo")


func _on_berry_button_pressed() -> void:
	buy("bamboo",prices["berry"].values()[0],"berry")


func _on_onion_button_pressed() -> void:
	buy("berry",prices["onion"].values()[0],"onion")


func _on_wheat_button_pressed() -> void:
	buy("corn",prices["wheat"].values()[0],"wheat")
