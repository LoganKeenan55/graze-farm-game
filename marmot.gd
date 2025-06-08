extends CharacterBody2D

const speed = 3000

@onready var navAgent = $NavigationAgent2D
var goal: Node
var isEating

func _ready() -> void:
	$NavigationAgent2D.target_position = goal.global_position
	$AnimationPlayer.play("walk")
	flipSprite()
	
func flipSprite():
	if goal.position.x > self.position.x:
		$Sprite2D.flip_h = true

func _physics_process(delta: float) -> void:
	handleMovingToTarget(delta)
	

func handleMovingToTarget(delta: float) -> void:
	if !goal:
		leave()
	if navAgent.distance_to_target() < 10:
		eatCrop()
		isEating = true
	else:
		var navPointDirection = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = navPointDirection * speed * delta
		move_and_slide()

func eatCrop():
	if !isEating:
		$AnimationPlayer.play("eat")
		$EatTimer.start()
		
func leave():
	get_parent().marmotArr.erase(self)
	queue_free()


func _on_eat_timer_timeout() -> void:
	goal.stateIndex = 1
	goal.createHarvestParticle()
	goal.updateTexture()
	$WaitTimer.start()

func _on_wait_timer_timeout() -> void:
	leave()
