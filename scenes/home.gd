extends Node2D

@onready var sprite = $Sprite2D

var upgrades = [
	["wheat", 20],
	["flower", 60],
	["onion", 100]
]

func _ready() -> void:
	GlobalVars.connect("save_loaded",setSprite)



func setSprite():
	print(sprite.frame)
	print(GlobalVars.homeLevel)
	sprite.frame = GlobalVars.homeLevel
	
func upgrade():
	if  GlobalVars.homeLevel+1 >= len(upgrades):
		return
	var currentUpgrade = upgrades[ GlobalVars.homeLevel]
	var crop = currentUpgrade[0]
	var price = currentUpgrade[1]

	
	if GlobalVars.player.inventory[crop] >= price:
		GlobalVars.player.recieve(crop,price)
		sprite.frame += 1
		GlobalVars.homeLevel += 1
	else:
		return
