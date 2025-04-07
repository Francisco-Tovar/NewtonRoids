extends CharacterBody2D

@onready var Vbackground: TextureRect = $"../background"
@onready var sfx_shot: AudioStreamPlayer2D = $sfx_shot
@onready var barra_potencia: TextureProgressBar = $BarraPotencia

const TURN_SPEED = 180
const MOVE_SPEED = 150
const ACC = 0.05
const DEC = 0.002
const MAX_POTENCIA = 5.0 # máximo de potencia

var proyectil = preload("res://scenes/proyectil.tscn")
@export var fire_rate = 0.2
var can_fire = true

@export var escudo = 3

var motion = Vector2.ZERO
var screen_size
var screen_buffer = 8

# NUEVO: variables para potencia cargada
var cargando_disparo := false
var tiempo_carga := 0.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	barra_potencia.max_value = MAX_POTENCIA
	barra_potencia.value = 0
	barra_potencia.visible = false

func _process(delta: float) -> void:
	# Comenzar a cargar
	if Input.is_action_just_pressed("shoot") and can_fire:
		cargando_disparo = true
		tiempo_carga = 0.0
		barra_potencia.visible = true
	
	# Soltar y disparar
	if Input.is_action_just_released("shoot") and cargando_disparo:
		cargando_disparo = false
		barra_potencia.visible = false
		var potencia_disparo = clamp(tiempo_carga, 1.0, MAX_POTENCIA)
		fire(potencia_disparo)

	# Mientras se mantiene apretado, carga
	if cargando_disparo:
		tiempo_carga += delta
		barra_potencia.value = clamp(tiempo_carga, 0, MAX_POTENCIA)

func fire(potencia: float):
	var _disparo = proyectil.instantiate()
	_disparo.potencia = potencia
	_disparo.dir = rotation
	_disparo.global_position = $gun.global_position
	_disparo.rota = global_rotation
	get_parent().add_child(_disparo)

	# Retroceso proporcional a la potencia
	var recoil_force = -Vector2(1, 0).rotated(rotation) * (0.3 * potencia)
	motion += recoil_force

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
	
	position += motion * MOVE_SPEED * delta
	
	Vbackground.material.set_shader_parameter("xSpeed", motion.x * 0.015)
	Vbackground.material.set_shader_parameter("ySpeed", motion.y * 0.015)
	
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
