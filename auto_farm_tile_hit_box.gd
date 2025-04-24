extends "res://tile_hitbox.gd"

func _ready() -> void:
	removeParticlePreload = preload("res://autoFarmerParticle.tscn")

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			pass
		"shovel":
			handleDeletingTile(event)
		"seeds":
			handleSeeding()
		"hammer":
			handleHammer()
