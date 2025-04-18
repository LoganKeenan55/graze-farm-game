extends "res://farm_tile.gd"
func _ready():
	textureRegions = {
		"unfertile": Rect2(0, 0, 16, 16),
		"fertile": Rect2(0, 16, 16, 16),
		"seeded": Rect2(0, 32, 16, 16),
		"growing": Rect2(0, 48, 16, 16),
		"harvestable": Rect2(0, 64, 16, 32)
	}
	cropType = "wheat"
	super._ready()
	
func harvestCrop():
	super.harvestCrop()
