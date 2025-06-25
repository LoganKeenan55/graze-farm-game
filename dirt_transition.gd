extends Node2D

var farmTilePreload = preload("res://FarmTile.tscn")
var particlePreload = preload("res://bigger_dirt_particle.tscn")

func _process(delta: float) -> void:
	if  GlobalVars.player:
		position = GlobalVars.player.position - Vector2(167,95)


var posArr = [
	Vector2(0, 0),
	Vector2(0, 16),
	Vector2(0, 32),
	Vector2(16, 32),
	Vector2(16, 16),
	Vector2(16, 0),
	Vector2(32, 0),
	Vector2(32, 16),
	Vector2(32, 32),
	Vector2(48, 32),
	Vector2(48, 16),
	Vector2(48, 0),
	Vector2(64, 0),
	Vector2(64, 16),
	Vector2(64, 32)
]
	
	

func closeTransition() -> void:
	z_index = 50
	var tiles = $Tiles
	#create dirt 
	for i in posArr:
		var newTile = farmTilePreload.instantiate()
		newTile.position = i
		tiles.add_child(newTile)
		newTile.playerCol.collision_layer = 0
		newTile.playerCol.collision_mask = 0
		newTile.sprite.flip_h = false
		newTile.waterSources.clear()
		newTile.stateIndex = 0
		newTile.updateTexture()
		SoundManager.play_sound("res://sounds/dirt_sound.mp3")
		await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://main.tscn")
func openTransition() -> void:
	z_index = 50
	#create initial dirt to remove
	for i in posArr:
		var newTile = farmTilePreload.instantiate()
		newTile.position = i
		
		$Tiles.add_child(newTile)
		
		newTile.sprite.flip_h = false
		newTile.playerCol.collision_layer = 0
		newTile.playerCol.collision_mask = 0
		
		newTile.currentCollisions = { 
			"left": true,
			"right": true,
			"up": true,
			"down": true
			}
		newTile.updateTexture()
		
	#remove
	var tiles = $Tiles.get_children()
	for i in range(tiles.size() - 1, -1, -1):  #from last index to 0
		var tile = tiles[i]
		var particle = particlePreload.instantiate()
		particle.z_index = 49
		particle.global_position = tiles[i].get_global_position()

	
		particle.get_child(0).emitting = true
		get_parent().add_child(particle)
		tile.queue_free()
		SoundManager.play_sound(tile.sound)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	queue_free()
	
