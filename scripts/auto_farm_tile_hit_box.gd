extends "res://scripts/tile_hitbox.gd"

func _ready() -> void:
	removeParticlePreload = preload("res://scenes/autoFarmerParticle.tscn")

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			pass
		"shovel":
			handleDeletingTile()
		"seeds":
			handleSeeding()
		"hammer":
			handleHammer()
