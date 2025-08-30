extends Node2D

var fireflyPreload = preload("res://scenes/Firefly.tscn")
var fireflyArr = []

var maxFireflies = 30

func _ready() -> void:
	GlobalFarmTileManager.connect("night_started", Callable(self, "setNight"))
	GlobalFarmTileManager.connect("day_started", Callable(self, "setDay"))
	await get_tree().create_timer(1).timeout
	onReadyCheck()

	
func setNight():
	$Timer.start()
		
func onReadyCheck():
	if GlobalFarmTileManager.getNightDay() == "night":
		setNight()
		print("night")
	if GlobalFarmTileManager.getNightDay() == "day":
		setDay()
		print("day")
func setDay():
	queueAllFireflies()
	$Timer.stop()

func findPlaceToSpawnFirefly() -> Vector2: #760 1450
	var randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
	return randomVector


func _on_timer_timeout() -> void:
	spawnFirefly()

func spawnFirefly():
	if fireflyArr.size() > maxFireflies:
		$Timer.stop()
		return
	var newFirefly = fireflyPreload.instantiate()
	newFirefly.position = findPlaceToSpawnFirefly()
	add_child(newFirefly)
	fireflyArr.append(newFirefly)
	$Timer.start()
	
func queueAllFireflies():
	for firefly:Node2D in fireflyArr:
		firefly.queue_free()
	
	fireflyArr.clear()
