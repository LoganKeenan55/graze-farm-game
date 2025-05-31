extends Node

var allFarmTiles = []
var timeElapsed = 0.0
var tickSpeed = 0.5
var overTile
var wheatGrowPerMinute: float

var autoFarmElapsed = 0.0
var autoFarmInterval = 10.0 # 10 seconds

var globalTimeElapsed = 0.0
var globalTimeInterval = 5

signal night_started
signal day_started

func _process(delta: float) -> void:
	timeElapsed += delta
	autoFarmElapsed += delta
	globalTimeElapsed += delta
	if timeElapsed >= tickSpeed:
		growFarmTiles()
		flowWater()
		timeElapsed = 0
	if autoFarmElapsed >= autoFarmInterval:
		activateAutoFarmers()
		autoFarmElapsed = 0
	if globalTimeElapsed >= globalTimeInterval:
		
		GlobalVars.globalTime += 1
		globalTimeElapsed = 0
		if GlobalVars.globalTime == 21:
			emit_signal("night_started")
		if GlobalVars.globalTime == 7:
			emit_signal("day_started")
		if GlobalVars.globalTime == 25:
			GlobalVars.globalTime = 1
	if Input.is_action_just_pressed("tab"):
		GlobalVars.globalTime = 23
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
