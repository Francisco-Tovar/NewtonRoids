extends Area2D

@export var mass: int = 100
@export var min_speed: float = 15.0
@export var max_speed: float = 30.0

var velocity = Vector2.ZERO

func _ready():
	randomize()
	_set_random_direction()
	_set_random_speed()

func _process(delta):
	position += velocity * delta
	_wrap_around_screen()

func _set_random_direction():
	var screen_size = get_viewport().size
	var center = Vector2(screen_size) / 2
	var to_border = (position - center).normalized()
	velocity = to_border

func _set_random_speed():
	var speed = randf_range(min_speed, max_speed)
	velocity *= speed

func _wrap_around_screen():
	var screen_size = get_viewport().size
	if position.x < 0: position.x = screen_size.x
	elif position.x > screen_size.x: position.x = 0
	if position.y < 0: position.y = screen_size.y
	elif position.y > screen_size.y: position.y = 0

func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("hoyonegro"):
		print("SCORE!")
		queue_free()
	elif other.is_in_group("proyectil"):				
		print("Ateroid hit!")		
		queue_free()
	elif other.is_in_group("nave"):
		print("Asteroid crash!")		
		queue_free()
