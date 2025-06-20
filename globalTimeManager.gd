extends Node

var allFarmTiles = []
var timeElapsed = 0.0
var tickSpeed = 0.5
var overTile
var wheatGrowPerMinute: float

var marmotTimeElapsed = 0.0
var marmotTimeInterval = 10.0 # 10 seconds

var globalTimeElapsed = 0.0
var globalTimeInterval = 5

signal night_started
signal day_started
signal spawnMarmot

func _process(delta: float) -> void:
	timeElapsed += delta
	marmotTimeElapsed += delta
	globalTimeElapsed += delta
	if timeElapsed >= tickSpeed:
		growFarmTiles()
		flowWater()
		
		timeElapsed = 0
	
	if marmotTimeElapsed >= marmotTimeInterval:
		callMarmotSpawner()
		marmotTimeElapsed = 0
	if globalTimeElapsed >= globalTimeInterval:
		
		GlobalVars.globalTime += 1
		globalTimeElapsed = 0
		if GlobalVars.globalTime == 21:
			emit_signal("night_started")
		if GlobalVars.globalTime == 6:
			emit_signal("day_started")
		if GlobalVars.globalTime == 25:
			GlobalVars.globalTime = 1
	
func growFarmTiles():
	for crop in get_tree().get_nodes_in_group("farmTiles"):
		if crop:
			crop.advanceState()


func flowWater():
	for water in get_tree().get_nodes_in_group("waterTiles"):
		if water:
			water.flow()

func callMarmotSpawner():
	if randi_range(1,3) != 1:
		return
	emit_signal("spawnMarmot")
