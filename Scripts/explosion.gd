class_name Explosion

extends Node2D

@export var particles : CPUParticles2D

func explode() -> void:
	particles.restart()

func _on_cpu_particles_2d_finished() -> void:
	queue_free()
