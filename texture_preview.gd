extends Sprite2D

var isBeingUsed = false
var atlasTexture: Texture2D = preload("res://textureAtlas.png")
var stateIndex:int = 0 #what state is tile in
var tileState = ["farm","water","brickTile","autoFarmTile"]
@onready var player = get_node("../Player")

var textureRegions = {
	"farm": Rect2(0, 0, 16, 16),
	"water": Rect2(0, 96, 16, 16),
	"brickTile": Rect2(0, 128, 16, 16),
	"autoFarmTile": Rect2(16, 112, 16, 16)
}

func _process(_delta: float) -> void:
	position = Vector2(
		snapped(get_global_mouse_position().x, 16),
		snapped(get_global_mouse_position().y, 16))
	
func _ready() -> void:
	$AnimationPlayer.play("fade")
	
	updateTexture()
func _on_area_2d_area_exited(_area: Area2D) -> void:
	GlobalFarmTileManager.overTile = false
	self_modulate.b = 1
	self_modulate.g = 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(player.placeableTiles[player.currentTile] != "brickTile") or area != player.get_node("HitBox"):
		GlobalFarmTileManager.overTile = true
		self_modulate.b = 0
		self_modulate.g = 0
		self_modulate.r = 1

func updateTexture():
	
	var currentState = tileState[stateIndex]
	if currentState in textureRegions:
		var atlas = AtlasTexture.new()
		atlas.atlas = atlasTexture
		atlas.region = textureRegions[currentState]
		texture = atlas  #apply the new texture region
