extends Node2D

@onready var dirtTransition = $DirtTransition
@onready var sceneAnimationPlayer = $SceneAnimatonPlayer
@onready var fade = $Fade
@onready var introPreload = preload("res://scenes/Intro.tscn")

var maleIntroText = "You’ve finally done it you accomplished your dream of building a farm worthy of your true love.

Everything is ready. You work up the nerve to send her a letter, hoping she will love what you have created for her.

You wait for days. With each passing day, your hope that she’ll ever respond begins to fade.

After a long day of farming and fending off marmots, you head to bed."

var femaleIntroText = "You’ve finally done it you accomplished your dream of building a farm worthy of your true love.

Everything is ready. You work up the nerve to send him a letter, hoping he will love what you have created for him.

You wait for days. With each passing day, your hope that he'll ever respond begins to fade.

After a long day of farming and fending off marmots, you head to bed."

var loveText = " \"Hey, I got your letter... Did you really do all of this for me? Can I come inside?\""

func _ready() -> void:
	setBeginninggSprite()
	dirtTransition.createTiles()
	var intro = introPreload.instantiate()
	add_child(intro)
	intro.setText(maleIntroText if GlobalVars.playerGender == "male" else femaleIntroText)
	intro.animateText()
	intro.scale = Vector2(.4,.4)
	intro.position.y += 10
	if GlobalVars.playerGender == "male":
		$Scene3/Boy.visible = false
	if GlobalVars.playerGender == "female":
		$Scene3/Girl.visible = false
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
	$Door/DoorOpen.play()
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
	get_tree().change_scene_to_file("res://scenes/EndOutside.tscn")
