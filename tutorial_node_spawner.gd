extends Node2D
class_name TutorialNodeSpawner
#System for spawning tutorial nodes during new game. Add to setArr() to add tutorial Nodes. "string", "input"

var nodesArr = []
var nodeIndex = 0
var tutorialNodePreload = preload("res://scenes/TutorialNode.tscn")
var started = false

#for not letting player continue tutorial without waiting for waitTime bewteen nodes
var canContinue = true
var waitTime = 3

func _ready() -> void:
	setArr()

func _process(delta: float) -> void:
	if !started or !canContinue:
		return
	var input = nodesArr[nodeIndex][1]
	if Input.is_action_just_pressed(input):
		nodeIndex += 1
		
		
		if nodeIndex >= nodesArr.size():
			queue_free()
			return
		createTutorialNode(nodesArr[nodeIndex][0],nodesArr[nodeIndex][1], waitTime)
		canContinue = false
		await get_tree().create_timer(waitTime).timeout
		canContinue = true

func setArr() -> void:
	nodesArr.append(["Use WASD to move", "w"])
	nodesArr.append(["Use E and F to switch between placing and farming mode", "f"])
	nodesArr.append(["Use number keys to switch between hotbar slots", "3"])
	nodesArr.append(["Equip dirt and press left click to place", "click"])
	nodesArr.append(["Equip water and place next to dirt to fertalize it", "click"])
	nodesArr.append(["Go to farming mode with f and equip seeds with 3", "3"])
	nodesArr.append(["Click on a farm tile with seeds equip to plant", "click"])
	nodesArr.append(["While seeds are equipped, you can hit 3 again to switch seeds", "3"])
	nodesArr.append(["Switch to hoe to harvest crops", "1"])
	nodesArr.append(["Use tab to open shop menu. You can buy bamboo for wheat", "tab"])
	nodesArr.append(["Use the hammer to upgrade your house", "4"])
	#nodesArr.append(["Use ", ""]) <= STARTER

func start() -> void:
	createTutorialNode(nodesArr[nodeIndex][0],nodesArr[nodeIndex][1], waitTime)
	canContinue = false
	await get_tree().create_timer(waitTime).timeout
	canContinue = true
	started = true
	
func createTutorialNode(text:String, input: String, waitTime: float) -> void:
	var newTutorialNode: TutorialNode = tutorialNodePreload.instantiate()
	GlobalVars.player.add_child(newTutorialNode)
	newTutorialNode.constructor(text, input, waitTime)
