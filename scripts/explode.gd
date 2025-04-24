extends Node2D

var deathParticle = preload("res://scenes/gpu_particles_2d.tscn")

func _ready() -> void:	
	kill()
	
func kill():
	var _particle = deathParticle.instantiate()
	_particle.position  = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	await get_tree().create_timer(0.5).timeout
	queue_free()
