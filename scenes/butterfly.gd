extends Node2D

var speed = 30
var  direction : Vector2
@onready var fade = $Fade
func _ready() -> void:
	$AnimationPlayer.play("fly")
	setDirection()
	setSprite()
	fade.play("fade_in")
func _process(delta: float) -> void:
	position += direction * speed * delta
	

func setDirection() -> void:
	var randAngle
	randAngle = randf() * TAU
	direction = Vector2.from_angle(randAngle)
	$Sprite2D.flip_h = direction.x > 0

func setSprite() -> void:
	
	if randi() % 2 == 0:
		$Sprite2D.texture = load("res://world_sprites/butterfly.png")
	else:
		$Sprite2D.texture = load("res://world_sprites/butterfly2.png")


func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		queue_free()
