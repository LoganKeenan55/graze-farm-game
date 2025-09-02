extends Node2D

@onready var sprite = $Sprite2D

var upgrades = [
	["wheat", 20],
	["flower", 60],
	["onion", 100]
]
var upgradesIndex = 0

func getData():
	var nodeData = {}
	nodeData["group"] = "home"
	nodeData["upgradeIndex"] = upgradesIndex
	return nodeData

func upgrade():
	if upgradesIndex+1 >= len(upgrades):
		return
	var currentUpgrade = upgrades[upgradesIndex]
	var crop = currentUpgrade[0]
	var price = currentUpgrade[1]
	print("1")
	
	if GlobalVars.player.inventory[crop] >= price:
		GlobalVars.player.recieve(crop,price)
		sprite.frame += 1
		upgradesIndex += 1
	else:
		return
