extends "res://tile_hitbox.gd"

func _ready() -> void:
	removeParticlePreload = preload("res://RemoveParticle.tscn")

func handlePlayerInterection(event):
	match player.items[player.currentItem]:
		"hoe":
			handleHarvesting()
		"shovel":
			
			handleDeletingTile(event)
		"seeds":
			handleSeeding()
		"wrench":
			handleWrench()
