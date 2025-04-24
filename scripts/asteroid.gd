extends Area2D

@export var mass: int = 100
@export var min_speed: float = 15.0
@export var max_speed: float = 30.0
@export var rotation_speed: float = 1.0
@onready var sprite_2d: Sprite2D = $Sprite2D

var explosion = preload("res://scenes/ExplodeNode.tscn")
var velocity = Vector2.ZERO

func _ready():
	randomize()
	_set_random_direction()
	_set_random_speed()
	rotation_speed = randf_range(-1, 1)
	_update_mass_display()
	$MassLabel.visible = true
	_update_visual()

func _process(delta):
	position += velocity * delta
	rotation += rotation_speed * delta	
	_wrap_around_screen()

func _set_random_direction():
	var screen_size = get_viewport().size
	var center = Vector2(screen_size) / 2
	var to_border = (position - center).normalized()
	velocity = to_border

func _set_random_speed():
	var speed = randf_range(min_speed, max_speed)
	velocity *= speed

func get_mass() -> int:
	return mass

func explode():
	var _explosion = explosion.instantiate()
	_explosion.global_position = global_position
	get_tree().get_current_scene().add_child(_explosion)

func _wrap_around_screen():
	var screen_size = get_viewport().size
	if position.x < 0: position.x = screen_size.x
	elif position.x > screen_size.x: position.x = 0
	if position.y < 0: position.y = screen_size.y
	elif position.y > screen_size.y: position.y = 0

func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("hoyonegro"):
		SfxExplosion.play()
		Score.update_score(mass * 10)
		explode()
		queue_free()
	elif other.is_in_group("proyectil"):
		explode()
		_update_visual()
	elif other.is_in_group("nave"):
		explode()
		queue_free()
	elif other.is_in_group("Asteroid"):
		# Colisión visual entre asteroides (no daña)
		_process_asteroid_collision(other)

func _process_asteroid_collision(other: Area2D):
	if other == self:
		return
	var direction = (global_position - other.global_position).normalized()
	var bounce_force = 30.0
	if "velocity" in other:
		velocity += direction * bounce_force
		other.velocity -= direction * bounce_force

func _update_mass_display():
	if has_node("MassLabel"):
		$MassLabel.text = str(mass)

func reduce_mass(amount: int):
	mass -= amount
	if mass < 0:
		mass = 0
	$MassLabel.visible = true
	_update_mass_display()
	_update_visual()
	_check_destroy()	

func _check_destroy():
	if mass <= 0:
		SfxExplosion.play()
		explode()
		queue_free()

func _update_visual():
	var _scale = sprite_2d.scale
	var perc = (mass * 100)/150	
	sprite_2d.scale = _scale * perc/100	
	if mass > 90:
		sprite_2d.self_modulate = Color.WHITE
	elif mass > 50:
		sprite_2d.self_modulate = Color.ORANGE
	else:
		sprite_2d.self_modulate = Color.RED

func push_from_impact(impact_dir: Vector2, force: float = 100.0):
	velocity += impact_dir.normalized() * force
