extends Node2D

var atlasTexture: Texture2D = preload("res://textureAtlas.png")

@onready var items = get_parent().items

var stateIndex = 0
var item = 0

var textureRegions = GlobalVars.textureRegions


func _ready() -> void:
	updateTexture()
	z_index = 11
	#Input.set_custom_mouse_cursor($Sprite2D.texture,0,Vector2(0,0))
	
		
func updateTexture():
	var textureName: String
	if items[item] == "seeds":
		match get_parent().currentSeed:
			0: textureName = "wheatSeeds"
			1: textureName = "cornSeeds"
	else:
		textureName = items[item]

	if textureName in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[textureName]
		$Sprite2D.texture = atlas
	else:
		print("Missing texture for:", textureName)
	#print(textureName)


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() -  Vector2(158,90)
	
