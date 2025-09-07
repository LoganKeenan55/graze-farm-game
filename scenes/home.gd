extends Node2D

@onready var sprite = $Sprite2D

var upgrades = [
	["wheat", 20, "Crops drop more seeds"],
	["flower", 60, "Crops grow faster"],
	["onion", 100, "Farm finished"]
]

func _ready() -> void:
	GlobalVars.connect("save_loaded",setSprite)



func setSprite():
	print(sprite.frame)
	print(GlobalVars.homeLevel)
	sprite.frame = GlobalVars.homeLevel
	
func upgrade():

	var currentUpgrade = upgrades[ GlobalVars.homeLevel]
	var crop = currentUpgrade[0]
	var price = currentUpgrade[1]

	
	if GlobalVars.player.inventory[crop] >= price:
		GlobalVars.player.recieve(crop,price)
		sprite.frame += 1
		GlobalVars.homeLevel += 1
		Util.createPopUp("Home upgraded! " + currentUpgrade[2],2,.5)
		$AnimationPlayer.play("upgrade")
		match GlobalVars.homeLevel:
			1:
				GlobalFarmTileManager.extraDropRate = 1
			2:
				GlobalFarmTileManager.tickSpeed = .35
				print("ee")
			3:
				print("yey")
				GlobalVars.finishGame()
	else:
		return
