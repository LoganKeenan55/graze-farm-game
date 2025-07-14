extends Node2D

var butterflyPreload = preload("res://scenes/Butterfly.tscn")
var butterflyArr = []

var maxButterflies = 30

func _ready() -> void:
	GlobalFarmTileManager.connect("night_started", Callable(self, "setNight"))
	GlobalFarmTileManager.connect("day_started", Callable(self, "setDay"))
	$Timer.start()
func setNight():
	queueAllFireflies()
	$Timer.stop()
	
		

func setDay():
	$Timer.start()
	

func findPlaceToSpawnbutterfly() -> Vector2: #760 1450
	var randomVector = Vector2(randi_range(32,1400),randi_range(32,720))
	return randomVector


func _on_timer_timeout() -> void:
	spawnButterfly()

func spawnButterfly():
	
	if butterflyArr.size() > maxButterflies:
		$Timer.stop()
		return
	print(butterflyArr.size())
	var newButterfly = butterflyPreload.instantiate()
	newButterfly.position = findPlaceToSpawnbutterfly()
	add_child(newButterfly)
	butterflyArr.append(newButterfly)
	$Timer.start()
	
	
func queueAllFireflies():
	for butterfly:Node2D in butterflyArr:
		butterfly.fade.play("fade_out") #handles freeing
		print("he")
	butterflyArr.clear()
