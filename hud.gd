extends Node2D

@onready var player = self.get_parent()



func _ready() -> void:
	z_index = 10
	$NightTimeFilter.z_index = 5
	GlobalFarmTileManager.connect("night_started", Callable(self, "setNight"))
	GlobalFarmTileManager.connect("day_started", Callable(self, "setDay"))

func _process(_delta: float) -> void:
	$Control/VBoxContainer/HBoxContainer/WheatCount.text = str(player.inventory["wheat"])
	$Control/VBoxContainer/HBoxContainer2/CornCount.text = str(player.inventory["corn"])
	$Control/VBoxContainer/HBoxContainer3/BambooCount.text = str(player.inventory["bamboo"])
	$Control/VBoxContainer/HBoxContainer4/BerryCount.text = str(player.inventory["berry"])
	$Control/VBoxContainer/HBoxContainer5/OnionCount.text = str(player.inventory["onion"])
	$time.text = str(GlobalVars.globalTime)

func setNight():
	SoundManager.play_ui_sound("res://sounds/turn_night.mp3",.3)
	$NightTimeFilter/NightFilterAnimationPlayer.play("turn_night")
	$NightTimeFilter.visible = true
func setDay():
	SoundManager.play_ui_sound("res://sounds/turn_day.mp3",.3)
	$NightTimeFilter/NightFilterAnimationPlayer.play("turn_day")
	$NightTimeFilter.visible = true
