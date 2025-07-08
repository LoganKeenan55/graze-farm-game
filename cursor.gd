extends Node2D

const atlasTexture: Texture2D = preload("res://textureAtlas.png")

@onready var items = get_parent().items

var item = 0

var textureRegions = GlobalVars.textureRegions


func _ready() -> void:
	updateTexture()
	z_index = 52
	#Input.set_custom_mouse_cursor($Sprite2D.texture,0,Vector2(0,0))
	
		
func updateTexture():
	var textureName: String
	#if get_parent().mode == "farming" or get_parent().mode == "nothing":
	if items[item] == "seeds" and get_parent().mode == "farming":
		match get_parent().currentSeed:
			0: textureName = "wheatSeeds"
			1: textureName = "bambooSeeds"
			2: textureName = "flowerSeeds"
			3: textureName = "pepperSeeds"
			4: textureName = "cornSeeds"
			5: textureName = "berrySeeds"
			6: textureName = "onionSeeds"
	elif get_parent().mode == "farming":
		textureName = items[item]
	else:
		textureName = "cursor"
	if textureName in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[textureName]
		$Sprite2D.texture = atlas
	else:
		print("Missing texture for:", textureName)


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() -  Vector2(158,90)
