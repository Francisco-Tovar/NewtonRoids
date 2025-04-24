extends Node2D

@export var asteroid_scene: PackedScene
@export var max_asteroids: int = 10
@export var spawn_margin: float = 100.0


func _ready():
	spawn_asteroids()

func spawn_asteroids():
	var screen_size = get_viewport().size
	for i in range(max_asteroids):
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = Vector2(
			randf_range(spawn_margin, screen_size.x - spawn_margin),
			randf_range(spawn_margin, screen_size.y - spawn_margin)
		)
		asteroid.mass = randi_range(50, 150)
		add_child(asteroid)
