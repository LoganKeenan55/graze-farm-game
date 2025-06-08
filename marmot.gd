extends CharacterBody2D

const speed = 3000

@onready var navAgent = $NavigationAgent2D
var goal: Node

func _ready() -> void:
	$NavigationAgent2D.target_position = goal.global_position
	$AnimationPlayer.play("walk")
	flipSprite()
	
func flipSprite():
	if goal.position.x > self.position.x:
		$Sprite2D.flip_h = true

func _physics_process(delta: float) -> void:
	handleMovingToTarget(delta)
	
func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != goal.global_position:
		$NavigationAgent2D.target_position = goal.global_position
	$Timer.start()

func handleMovingToTarget(delta: float) -> void:
	if !goal:
		leave()
	if navAgent.distance_to_target() < 10:
		eatCrop()
	else:
		var navPointDirection = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = navPointDirection * speed * delta
		move_and_slide()

func eatCrop():
	$AnimationPlayer.play("eat")

func leave():
	get_parent().marmotArr.erase(self)
	queue_free()
