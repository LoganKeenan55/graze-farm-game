extends Node2D
class_name TutorialNode

var actionNeeded:String
var offset = Vector2(15, 70)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(actionNeeded):
		$AnimationPlayer.play("Close")
	position = GlobalVars.player.position + offset
func _ready() -> void:
	if self != null:
		$AnimationPlayer.play("Open")
		z_index = 30

func setText(text:String):
	$ColorRect/Label.text = text


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Close":
		queue_free()

func constructor(text:String, newActionNeeded:String):
	setText(text)
	actionNeeded = newActionNeeded
	
