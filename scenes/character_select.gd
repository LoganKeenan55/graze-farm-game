extends Node2D

var maleVoiceLines = []
var femaleVoiceLines = []

func _ready() -> void:
	setArrs()

func setArrs():
	femaleVoiceLines.append("res://sounds/voicelines/female/hello1.mp3")
	femaleVoiceLines.append("res://sounds/voicelines/female/hi1.mp3")
	femaleVoiceLines.append("res://sounds/voicelines/female/howdy1.mp3")
	femaleVoiceLines.append("res://sounds/voicelines/female/howdy2.mp3")
	femaleVoiceLines.append("res://sounds/voicelines/female/party.mp3")
	femaleVoiceLines.append("res://sounds/voicelines/female/woo1.mp3")
	maleVoiceLines.append("res://sounds/voicelines/male/hey1.mp3")
	maleVoiceLines.append("res://sounds/voicelines/male/hi1.mp3")
	maleVoiceLines.append("res://sounds/voicelines/male/howdy1.mp3")
	maleVoiceLines.append("res://sounds/voicelines/male/woo1.mp3")
	maleVoiceLines.append("res://sounds/voicelines/male/hello1.mp3")
func _on_female_button_pressed() -> void:
	GlobalVars.playerGender = "female"
	get_parent().arrow.position.x = 103
	var randVoiceLine = femaleVoiceLines[randi_range(0,femaleVoiceLines.size()-1)]
	SoundManager.play_ui_sound(randVoiceLine)
func _on_male_button_pressed() -> void:
	GlobalVars.playerGender = "male"
	get_parent().arrow.position.x = 74
	var randVoiceLine =	maleVoiceLines[randi_range(0,maleVoiceLines.size()-1)]
	SoundManager.play_ui_sound(randVoiceLine)
