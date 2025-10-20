extends Node2D

@onready var dirtTransition = $DirtTransition
@onready var sceneAnimationPlayer = $SceneAnimatonPlayer
@onready var introPreload = preload("res://scenes/Intro.tscn")

var introText = "You have finally did it, you acomplished your dream of making a farm worthy for your true love.

Everything is ready, you work up the nerve of sending her a letter invtiting her to see what you have made for her. 

You wait for days. Every day you give up hope that she will ever even respond.

After a long day of farming and fighting off marmots you head to bed. "

var loveText = " \"Hey, I got your letter... Did you really do all of this for me? Can I come inside?\""

func _ready() -> void:
	setBeginninggSprite()
	dirtTransition.createTiles()
	var intro = introPreload.instantiate()
	add_child(intro)
	intro.setText(introText)
	intro.animateText()
	intro.scale = Vector2(.4,.4)
	intro.position.y += 10

func _process(_delta: float) -> void:
	#if GlobalVars.debugging:
	if Input.is_action_just_pressed('`'):
		get_tree().quit()

func setBeginninggSprite():
	if GlobalVars.playerGender == "male":
		$Player.frame = 0
		$Scene3/Boy.visible = false
	if GlobalVars.playerGender == "female":
		$Player.frame = 2
		$Scene3/Girl.visible = false
func openEyes():
	if GlobalVars.playerGender == "male":
		$Player.frame = 1
	if GlobalVars.playerGender == "female":
		$Player.frame = 3

func moveToDoor():
	$Camera2D.position.x = 300
	await get_tree().create_timer(1).timeout
	$Door.play("open")
	$SceneAnimatonPlayer.play("Door")
	
func moveToOutside():
	$Camera2D.position.x = 600
	$Scene3/OutsideAnimationPlayer.play("fadeIn")
	var intro = introPreload.instantiate()
	add_child(intro)
	intro.setText(loveText)
	intro.animateText()
	intro.scale = Vector2(.4,.4)
	intro.position += Vector2(600,10)
	intro.label.horizontal_alignment = 1
	intro.buttonLabel.text = "Yes"

func moveToFuture():
	pass
