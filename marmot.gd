extends CharacterBody2D

const speed = 3000

@onready var navAgent = $NavigationAgent2D
var goal: Node

func _ready() -> void:
	$NavigationAgent2D.target_position = goal.global_position

func _physics_process(delta: float) -> void:
	handleMovingToTarget(delta)

func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != goal.global_position:
		$NavigationAgent2D.target_position = goal.global_position
	$Timer.start()

func handleMovingToTarget(delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached():
		var navPointDirection = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = navPointDirection * speed * delta
		move_and_slide()
