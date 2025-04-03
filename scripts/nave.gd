extends CharacterBody2D

@onready var Vbackground: TextureRect = $"../background"

const TURN_SPEED = 180
const  MOVE_SPEED = 150
const ACC = 0.05
const DEC = 0.002

var motion = Vector2.ZERO

var screen_size
var screen_buffer = 8

func _ready() -> void:
	screen_size = get_viewport_rect().size

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
