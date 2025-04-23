extends Node2D

@onready var sprite = $Sprite #need for all tiles
var atlasTexture: Texture2D = preload("res://textureAtlas.png")
var stateIndex:int = 0 #what state is tile in
var harvestable = false
var tileType
var inFrontOfPlayer: bool
var usesBlending = true


var currentCollisions = { 
	"left": false,
	"right": false,
	"up": false,
	"down": false
}


var blendTextureRegions = {
	"left_blend": Rect2(16, 0, 16, 16),
	"right_blend": Rect2(16, 16, 16, 16),
	"up_blend": Rect2(32, 0, 16, 16),
	"down_blend": Rect2(32, 16, 16, 16)
}


func _ready() -> void:
	updateTexture()
	manageBlending()

	
func getData(): #needed for all tiles
	pass

func updateTexture(): #needed for all tiles
	pass

func manageBlending():
	if usesBlending:
		for child in get_node("Blend").get_children():
			
			if child is Sprite2D:
				child.queue_free()

		if not currentCollisions["right"]:
			createBlendSprite("right_blend")
		if not currentCollisions["up"] and harvestable == false:
			createBlendSprite("up_blend")
		if not currentCollisions["left"]:
			createBlendSprite("left_blend")
		if not currentCollisions["down"]:
			createBlendSprite("down_blend")
		
func createBlendSprite(direction):
	var blendSprite = Sprite2D.new()
	var atlas = AtlasTexture.new()
	atlas.atlas = atlasTexture
	atlas.region = blendTextureRegions[direction]
	blendSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	blendSprite.texture = atlas  
	blendSprite.position = get_node("Blend").position
	get_node("Blend").add_child(blendSprite)
	
	#for item in get_children():
		#print(item)
		
		
		#if other is bellow and other harvestable == true then cc[down] = false

func findCurrentCollisions(area, entering: bool):
	if area.get_parent().has_method("manageBlending") and usesBlending and area.get_parent().usesBlending:
		var otherPosition = area.get_parent().position
		if  area.get_parent().tileType == self.tileType:
			if otherPosition.x == position.x:  
				if otherPosition.y > position.y:  #Other is below
					currentCollisions["down"] = entering
				elif otherPosition.y < position.y:  #Other is above
					currentCollisions["up"] = entering

			if otherPosition.y == position.y:
				if otherPosition.x > position.x:  #Other is to the right
					currentCollisions["right"] = entering
				elif otherPosition.x < position.x:  #Other is to the left
					currentCollisions["left"] = entering
			#if otherPosition.x == position.x:  
			#	if otherPosition.y > position.y and area.get_parent().harvestable == true:  #Other is below
				#	currentCollisions["down"] = false
			manageBlending()
