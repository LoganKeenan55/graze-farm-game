extends "res://scripts/tile_hitbox.gd"

func _ready() -> void:
	removeParticlePreload = preload("res://scenes/RemoveParticle.tscn")

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			handleHarvesting()
		"shovel":
			handleDeletingTile()
		"seeds":
			handleSeeding()
		"hammer":
			handleHammer()

		
