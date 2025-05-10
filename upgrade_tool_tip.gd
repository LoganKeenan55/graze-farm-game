extends Node2D

@onready var sprite = $Control/VBoxContainer/HBoxContainer2/Sprite
@onready var label = $Control/VBoxContainer/HBoxContainer/Label
@onready var price = $Control/VBoxContainer/HBoxContainer2/Price

func changeCropType(newType: String):
	var new_tex := AtlasTexture.new()
	new_tex.atlas = sprite.texture.atlas
	new_tex.region = GlobalVars.textureRegions[newType]
	sprite.texture = new_tex
