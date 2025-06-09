extends CharacterBody2D

const speed = 3000

@onready var navAgent = $NavigationAgent2D

var goal: Node
var isEating
var isLeaving

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
	if isLeaving:
		return
	if !goal:
		leave("leave")
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
		
func leave(str): #can be leave or leave_happy
	$AnimationPlayer.play(str)
	isLeaving = true


func _on_eat_timer_timeout() -> void:
	if isLeaving:
		return
	goal.stateIndex = 1
	goal.createHarvestParticle()
	goal.updateTexture()
	$WaitTimer.start()

func _on_wait_timer_timeout() -> void:
	leave("leave_happy")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "leave" or "leave_happy":
		get_parent().marmotArr.erase(self)
		queue_free()
