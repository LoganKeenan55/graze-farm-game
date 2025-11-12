extends Node2D

@onready var sprite = $Sprite2D
@onready var dirtTransitionPreload = preload("res://scenes/DirtTransition.tscn")

var upgrades = [
	["wheat", 50, "Crops drop more seeds"],
	["flower", 600, "Crops grow faster"],
	["onion", 1500, "Farm finished"]
]

func _ready() -> void:
	GlobalVars.connect("save_loaded",setSprite)


func setSprite():
	sprite.frame = GlobalVars.homeLevel
	if GlobalVars.homeLevel > 1:
		$Sprite2D/AnimatedSprite2D.visible = true
func upgrade():

	var currentUpgrade = upgrades[GlobalVars.homeLevel]
	var crop = currentUpgrade[0]
	var price = currentUpgrade[1]

	
	if GlobalVars.player.inventory[crop] >= price:
		#GlobalVars.player.receive(crop,-price) players seemed to like not losing any when upgrading
		sprite.frame += 1
		GlobalVars.homeLevel += 1
		Util.createPopUp("Home upgraded! " + currentUpgrade[2],2,.5)
		
		match GlobalVars.homeLevel:
			1:
				GlobalVars.extraDropRate = 1
				$AnimationPlayer.play("upgrade")
				$Sprite2D/AnimatedSprite2D.visible = true
				$Construction.play()
				emitParticles()
			2:
				GlobalFarmTileManager.tickSpeed = .42
				$AnimationPlayer.play("upgrade")
				$Construction.play()
				emitParticles()
			3:
				$Sprite2D/AnimatedSprite2D.play("open")
				$DoorSound.play()
	else:
		return

func endGame():
	var dirtTransition:DirtTransition = dirtTransitionPreload.instantiate()
	get_parent().get_parent().add_child(dirtTransition)
	dirtTransition.scale = Vector2(5,5)
	dirtTransition.closeTransition("uid://s6qymif8os4s")

	
func _on_animated_sprite_2d_animation_finished() -> void:
	$Sprite2D/AnimatedSprite2D.play("stay_open")
	endGame()

func emitParticles():
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true
