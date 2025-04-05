extends CharacterBody2D

@onready var Vbackground: TextureRect = $"../background"
@onready var sfx_shot: AudioStreamPlayer2D = $sfx_shot

const TURN_SPEED = 180
const  MOVE_SPEED = 150
const ACC = 0.05
const DEC = 0.002

var proyectil = preload("res://scenes/proyectil.tscn")
@export var fire_rate = 1
var can_fire = true

@export var escudo = 3

var motion = Vector2.ZERO
var screen_size
var screen_buffer = 8

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if Input.is_action_just_released("shoot") and can_fire:
		fire(1)

func fire(potencia: float):
	var _disparo = proyectil.instantiate()
	_disparo.potencia = potencia
	_disparo.dir = rotation
	_disparo.pos = $gun.global_position	
	_disparo.rota = global_rotation
	get_parent().add_child(_disparo)
	can_fire = false
	sfx_shot.play()
	await get_tree().create_timer(fire_rate).timeout	
	can_fire = true

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotation_degrees -= TURN_SPEED * delta	
	if Input.is_action_pressed("right"):
		rotation_degrees += TURN_SPEED * delta
	
	var moveDir = Vector2(1,0).rotated(rotation)
	
	if Input.is_action_pressed("accelerate"):
		motion = motion.lerp(moveDir, ACC)
	else:
		motion = motion.lerp(Vector2(0,0), DEC)
		
	if Input.is_action_pressed("decelerate"):
		motion = motion.lerp(-moveDir, ACC)
	else:
		motion = motion.lerp(Vector2(0,0), DEC)
	
	#actual moving
	position += motion * MOVE_SPEED * delta
	
	#background paralaxing
	Vbackground.material.set_shader_parameter("xSpeed", motion.x * 0.015)
	Vbackground.material.set_shader_parameter("ySpeed", motion.y * 0.015)
	
	#screen wrap
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)


func _on_area_2d_area_entered(other: Area2D) -> void:
	if other.is_in_group("hoyonegro"):
		print("YOU DIED!")
		queue_free()
	elif other.is_in_group("Asteroid"):
		escudo -= 1
		print("escudo -1 = " + str(escudo))
	
	if escudo <= 0:
		print("YOU DIED!")
		queue_free()		
		get_tree().get_node("game").reload()
	
	
