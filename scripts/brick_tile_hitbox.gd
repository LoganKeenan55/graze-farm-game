extends "res://scripts/tile_hitbox.gd"

func _ready() -> void:
	removeParticlePreload = preload("res://scenes/BrickRemoveParticle.tscn")

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			pass
		"shovel":
			
			handleDeletingTile()
		"seeds":
			pass
