extends Node2D

var prices = {
	"farmTile": {"wheat": 10},
	"waterTile" :{"corn": 30},
	"brickTile":{"bamboo": 20},
	"autoFarmTile":{"wheat": 100},
	"wheat":10,
	"corn":10,
	"bamboo":20
	
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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		queue_free()

func _on_farm_tile_button_pressed() -> void: 
	buy("wheat",prices["farmTile"].values()[0],"farmTile")
	
func _on_water_tile_button_pressed() -> void:
	buy("corn",prices["waterTile"].values()[0],"waterTile")


func _on_brick_tile_button_pressed() -> void:
	print("pressed")


func _on_auto_farm_tile_button_pressed() -> void:
	print("pressed")

func buy(cropType:String, amount:int, purchase:String):
	var inventory = GlobalVars.player.inventory
	if (inventory[cropType]-amount) >= 0:
		inventory[cropType] = inventory[cropType] - amount
		inventory[purchase] = inventory[purchase] + 1
		GlobalVars.player.hotBar.updateAll()
		
	else:
		return false
	
