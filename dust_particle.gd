extends Node2D


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
