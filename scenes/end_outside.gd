extends Node2D

func _ready() -> void:
	$Tractor.play()
	$Tractor/FadeIn.play("Fade")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("`"):
		Util.quitGame()
	moveTractor(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.get_parent().has_method("seedCrop"):
		return
	area.get_parent().seedCrop("flower")

func moveTractor(delta:float):
	$Tractor.position.x+= 50*delta


func _on_camera_switch_area_entered(_area: Area2D) -> void:
	$Tractor/TractorCamera.enabled = false
	$ThankYouCamera.enabled = true


func _on_end_area_entered(area: Area2D) -> void:
	$FadeOut.play("Fade")

func sendToMainMenu():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
