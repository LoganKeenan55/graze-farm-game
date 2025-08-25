extends Area2D
var forestMessagePreload = preload("res://scenes/ForestMessage.tscn")

func _ready() -> void:
	GlobalVars.connect("save_loaded",updateCollision)
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("recieve"):
		var newForestMessage = forestMessagePreload.instantiate()
		get_parent().get_parent().get_parent().add_child(newForestMessage)
		newForestMessage.position = area.get_parent().position

func updateCollision():
	var pepperUnlockLevel = 3
	if GlobalVars.player.unlockLevel >= pepperUnlockLevel:
		monitoring = false
		get_parent().disabled = true

		
func unlock():
	var newForestMessage = forestMessagePreload.instantiate()
	get_parent().get_parent().get_parent().add_child(newForestMessage)
	newForestMessage.position = GlobalVars.player.get_parent().position
	monitoring = false
	get_parent().disabled = true
	newForestMessage.label.text =  "[shake rate=20.0 level=5 connected=1][tornado radius=4.0 freq=2.0 connected=1]The forest is calling you[/tornado][/shake]"
