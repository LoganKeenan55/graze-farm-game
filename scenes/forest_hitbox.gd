extends Area2D
var forestMessagePreload = preload("res://scenes/ForestMessage.tscn")

func _ready() -> void:
	GlobalVars.connect("save_loaded",setCollision)
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("recieve"):
		var newForestMessage = forestMessagePreload.instantiate()
		get_parent().get_parent().get_parent().add_child(newForestMessage)
		newForestMessage.position = area.get_parent().position

func setCollision():
	var pepperUnlockLevel = 4
	if GlobalVars.player.unlockLevel >= pepperUnlockLevel:
		monitoring = false
		get_parent().disabled = true

		
