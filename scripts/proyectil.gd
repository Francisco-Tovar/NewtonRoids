extends CharacterBody2D

var pos : Vector2
var rota : float
var dir : float
@export var speed = 100
@export var potencia = 1

func _ready() -> void:
	global_position=pos
	global_rotation=rota

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed * potencia,0).rotated(dir)
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()	

func _on_area_entered(other: Area2D) -> void:
	queue_free()
