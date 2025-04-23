extends Node2D

var atlasTexture: Texture2D = preload("res://textureAtlas.png")

@onready var items = get_parent().items

var stateIndex = 0
var item = 0

var textureRegions = {
	"hoe": Rect2(240, 0, 16, 16),
	"seeds": Rect2(240, 16, 16, 16),
	"shovel": Rect2(240, 32, 16, 16),
	"wrench": Rect2(240, 32, 16, 16),
	"cursor": Rect2(240, 48, 16, 16),
	"wheat":Rect2(240, 16, 16, 16),
	"corn":Rect2(224, 16, 16, 16)
}


func _ready() -> void:
	updateTexture()
	z_index = 11
	#Input.set_custom_mouse_cursor($Sprite2D.texture,0,Vector2(0,0))
	
		
func updateTexture():
	var textureName: String
	if items[item] == "seeds":
		match get_parent().currentSeed:
			0: textureName = "wheat"
			1: textureName = "corn"
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
	
