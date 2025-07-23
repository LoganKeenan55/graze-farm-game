extends Node2D

var nodesArr = []

func _ready() -> void:
	setArr()

func setArr():
	nodesArr.append(["Use WASD to move", "w"])
	nodesArr.append(["Use E and F to switch between placing and farming mode", "f"])
