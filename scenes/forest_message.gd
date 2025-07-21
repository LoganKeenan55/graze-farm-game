extends Node2D
@onready var label = $RichTextLabel
func _ready() -> void:

	z_index = 50
	$AnimationPlayer.play("Trigger")
	SoundManager.play_ui_sound("res://sounds/scary.mp3",3)
	
func _process(delta: float) -> void:
	position = GlobalVars.player.position

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
