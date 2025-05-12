extends Node

var allFarmTiles = []
var timeElapsed = 0.0
var tickSpeed = 0.5
var overTile
var stateIndex:int = 0 #what state is tile in
var wheatGrowPerMinute: float

var autoFarmElapsed = 0.0
var autoFarmInterval = 10.0 # 10 seconds

func _process(delta: float) -> void:
	timeElapsed += delta
	autoFarmElapsed += delta
	if timeElapsed >= tickSpeed:
		growFarmTiles()
		flowWater()
		timeElapsed = 0
		
	if autoFarmElapsed >= autoFarmInterval:
		activateAutoFarmers()
		autoFarmElapsed = 0
	
func growFarmTiles():
	for crop in get_tree().get_nodes_in_group("farmTiles"):
		if crop:
			crop.advanceState()

func activateAutoFarmers():
	for autoFarmer in get_tree().get_nodes_in_group("autoFarmerTiles"):
		if autoFarmer:
			if autoFarmer.cropType != "default":
				autoFarmer.activate()


func flowWater():
	for water in get_tree().get_nodes_in_group("waterTiles"):
		if water:
			water.flow()
