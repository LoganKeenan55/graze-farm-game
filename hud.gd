extends Node2D

@onready var player = self.get_parent()



func _ready() -> void:
	z_index = 10

func _process(_delta: float) -> void:
	$Control/VBoxContainer/HBoxContainer/WheatCount.text = str(player.inventory["wheat"])
	$Control/VBoxContainer/HBoxContainer2/CornCount.text = str(player.inventory["corn"])
