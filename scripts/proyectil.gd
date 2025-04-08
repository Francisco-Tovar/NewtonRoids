extends CharacterBody2D  # Cambiado de Area2D a CharacterBody2D

var dir := 0.0
var potencia := 1.0
var rota := 0.0
var velocidad_base := 300.0

func _ready():
	rotation = rota
	scale = Vector2.ONE * clamp(potencia, 1.0, 3.0)

func _physics_process(delta):
	var move_vec = Vector2.RIGHT.rotated(dir) * velocidad_base * potencia * delta
	position += move_vec
	# Para CharacterBody2D, deberías usar:
	# velocity = move_vec / delta  # Convertir a velocidad por segundo
	# move_and_slide()

func _on_area_2d_area_entered(other: Area2D) -> void:
	if other.is_in_group("Asteroid"):		
		print("proyectil hit asteroid")
		queue_free()	
	elif other.is_in_group("hoyonegro"):		
		queue_free()
