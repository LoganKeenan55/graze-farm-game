extends Node2D

class_name ToolTip


@onready var sprite = $Control/VBoxContainer/HBoxContainer2/Sprite
@onready var topText = $Control/VBoxContainer/HBoxContainer/Label
@onready var priceText = $Control/VBoxContainer/HBoxContainer2/Price
@onready var colorRect = $Control/ColorRect 
func changeCropType(newType: String):
	var new_tex := AtlasTexture.new()
	new_tex.atlas = sprite.texture.atlas
	new_tex.region = GlobalVars.textureRegions[newType]
	sprite.texture = new_tex

func setToolTip(newCropType:String, newTopText:String, newPriceText:String):
	changeCropType(newCropType)
	topText.text = newTopText
	priceText.text = newPriceText
