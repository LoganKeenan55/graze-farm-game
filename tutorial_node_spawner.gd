extends Node2D

#System for spawning tutorial nodes during new game. Add to setArr() to add tutorial Nodes. "string", "input"

var nodesArr = []
var nodeIndex = 0
var tutorialNodePreload = preload("res://scenes/TutorialNode.tscn")
var started = false

func _ready() -> void:
	setArr()

func _process(delta: float) -> void:
	if !started:
		return
	var input = nodesArr[nodeIndex][1]
	if Input.is_action_just_pressed(input):
		nodeIndex += 1
		if nodeIndex >= nodesArr.size():
			queue_free()
			return
		createTutorialNode(nodesArr[nodeIndex][0],nodesArr[nodeIndex][1])
		

func setArr() -> void:
	nodesArr.append(["Use WASD to move", "w"])
	nodesArr.append(["Use E and F to switch between placing and farming mode", "f"])

func start() -> void:
	print("yay")
	createTutorialNode(nodesArr[nodeIndex][0],nodesArr[nodeIndex][1])
	started = true
func createTutorialNode(text:String, input: String) -> void:
	var newTutorialNode: TutorialNode = tutorialNodePreload.instantiate()
	add_child(newTutorialNode)
	newTutorialNode.constructor(text, input)
