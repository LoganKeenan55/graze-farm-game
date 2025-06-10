extends Node2D

@onready var sprite = $SpriteHolder/Item
@onready var front = $SpriteHolder/Front
@onready var back = $SpriteHolder/Back
@onready var indice  = $SpriteHolder/indice
@onready var amount = $SpriteHolder/amount
@onready var originalColor = front.modulate

var tileState = ["dirt", "water", "brick", "hoe", "harvestable"]
const atlasTexture: Texture2D = preload("res://textureAtlas.png")
var stateIndex:int = 0 #what state is tile in
var selected: bool = false



func _ready() -> void:
	setSelected(false)
	
func setTexture(texture: String):
	if texture in GlobalVars.textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = GlobalVars.textureRegions[texture]
		sprite.texture = atlas  #apply the new texture region

func setAmount(newAmount):
	if newAmount!= -1:
		amount.text = str(newAmount) 
	else:
		amount.visible = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("update_ammount")

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
