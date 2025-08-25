extends Node2D
class_name TutorialNode

var actionNeeded:String
var canClose = false

func _ready() -> void:
	$AnimationPlayer.play("Open")
	z_index = 30

func _process(delta: float) -> void:
	if canClose and Input.is_action_just_pressed(actionNeeded):
		$AnimationPlayer.play("Close")

func setText(text:String):
	$ColorRect/Label.text = text


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Close":
		queue_free()

func constructor(text:String, newActionNeeded:String, waitTime:float):
	setText(text)
	actionNeeded = newActionNeeded
	await get_tree().create_timer(waitTime).timeout
	canClose = true
