extends CharacterBody2D

@onready var Vbackground: TextureRect = $"../background"
@onready var sfx_shot: AudioStreamPlayer2D = $sfx_shot
@onready var sfx_ship_crash: AudioStreamPlayer2D = $SFX_shipCrash
@onready var power_bar: HBoxContainer = %PowerBar
@onready var lives: HBoxContainer = %Lives

@export var escudo = 3

const TURN_SPEED = 180
const MOVE_SPEED = 150
const ACC = 0.05
const DEC = 0.01
const MAX_POTENCIA = 5.0 # máximo de potencia

var proyectil = preload("res://scenes/proyectil.tscn")
var explosion = preload("res://scenes/ExplodeNode.tscn")
@export var fire_rate = 0.2
var can_fire = true
var can_move = true

var motion = Vector2.ZERO
var screen_size
var screen_buffer = 8

# NUEVO: variables para potencia cargada
var cargando_disparo := false
var tiempo_carga := 0.0

func _ready() -> void:
	screen_size = get_viewport_rect().size

func take_damage():
	if escudo > 0:
		escudo -= 1
		lives.SetLives(escudo)
		lives.DrawLives()

func _process(delta: float) -> void:
	# Comenzar a cargar
	if Input.is_action_just_pressed("shoot") and can_fire:
		cargando_disparo = true
		tiempo_carga = 0.0
	
	# Soltar y disparar
	if Input.is_action_just_released("shoot") and cargando_disparo:
		cargando_disparo = false		
		var potencia_disparo = clamp(tiempo_carga, 1.0, MAX_POTENCIA)
		fire(potencia_disparo)
		print("Potencia: " + str(potencia_disparo))
	# Mientras se mantiene apretado, carga
	if cargando_disparo:
		tiempo_carga += delta		
		power_bar.update_pbar(int(clamp(tiempo_carga, 1.0, MAX_POTENCIA)))
	else:
		power_bar.update_pbar(0)

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
	if can_move:
		if Input.is_action_pressed("left"):
			rotation_degrees -= TURN_SPEED * delta	
		if Input.is_action_pressed("right"):
			rotation_degrees += TURN_SPEED * delta
		
		var moveDir = Vector2(1,0).rotated(rotation)
		
		if Input.is_action_pressed("accelerate"):
			motion = motion.lerp(moveDir, ACC)
		else:
			motion = motion.lerp(Vector2(0,0), DEC)
		position += motion * MOVE_SPEED * delta
		
		Vbackground.material.set_shader_parameter("xSpeed", motion.x * 0.015)
		Vbackground.material.set_shader_parameter("ySpeed", motion.y * 0.015)
		
		position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
		position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
	else:
		motion = motion.lerp(Vector2(0,0), ACC)
		position += motion * MOVE_SPEED * delta

func explode():
	var _explosion = explosion.instantiate()
	_explosion.global_position = global_position
	get_parent().add_child(_explosion)

func _on_area_2d_area_entered(other: Area2D) -> void:
	if other.is_in_group("hoyonegro"):		
		visible = false;
		escudo = 0
		can_move = false
		lives.SetLives(escudo)
		lives.DrawLives()
		SfxExplosion.play()
		
	elif other.is_in_group("Asteroid"):
		take_damage()
		apply_knockback(other.global_position, 200.0)
	if other.has_method("push_from_impact"):
		var direction = (other.global_position - global_position).normalized()
		other.push_from_impact(direction, 50.0)
	sfx_ship_crash.play()
	if escudo <= 0:
		visible  = false;
		explode()
		can_move = false		
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func apply_knockback(from_position: Vector2, force: float = 200.0):
	var direction = (global_position - from_position).normalized()
	motion += direction * (force / MOVE_SPEED)
