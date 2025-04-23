extends Node2D

@onready var sprite = $SpriteHolder/Item
@onready var front = $SpriteHolder/Front
@onready var back = $SpriteHolder/Back
@onready var indice  = $SpriteHolder/indice
@onready var amount = $SpriteHolder/amount
@onready var originalColor = front.modulate

var tileState = ["dirt", "water", "brick", "hoe", "harvestable"]
var atlasTexture: Texture2D = preload("res://textureAtlas.png")
var stateIndex:int = 0 #what state is tile in
var selected: bool = false

var textureRegions = {
	"farmTile": Rect2(0, 0, 16, 16),
	"waterTile": Rect2(0, 96, 16, 16),
	"brickTile": Rect2(0,128 ,16 ,16),
	"autoFarmTile": Rect2(16, 112, 16, 16),
	
	"hoe": Rect2(240, 0, 16, 16),
	"shovel": Rect2(240, 32, 16, 16),
	"wheat":Rect2(240, 16, 16, 16),
	"corn":Rect2(224, 16, 16, 16),
	"wrench": Rect2(240, 32, 16, 16)
}

func _ready() -> void:
	setSelected(false)
	
func setTexture(texture: String):
	if texture in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[texture]
		sprite.texture = atlas  #apply the new texture region

func setAmount(newAmount):
	if newAmount!= -1:
		amount.text = str(newAmount) 
	else:
		amount.visible = false


func setSelected(input: bool):
	
	if input == true and selected == false: #SELECT
		front.self_modulate = Color(1, 0, 1, 1)
		back.self_modulate = Color(1, .7, .7, 1)
		#print("here"+ str(front.self_modulate))
		$AnimationPlayer.play("Selected")
		selected = true
	if input == false and selected == true: #DESELECT
		front.self_modulate = originalColor
		back.self_modulate = originalColor
		$AnimationPlayer.play("Deselected")
		selected = false
