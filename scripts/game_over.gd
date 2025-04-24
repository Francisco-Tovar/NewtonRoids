extends Control
@onready var mouse_over: AudioStreamPlayer2D = $mouseOver
@onready var mouse_off: AudioStreamPlayer2D = $mouseOff
@onready var click_confirmation: AudioStreamPlayer2D = $ClickConfirmation
@onready var final_score_label: Label = $GameOverPanel/FinalScoreLabel 

var not_clicked = true
var score = 0
var final_score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_salir_menu_pressed() -> void:
	if not_clicked:
		not_clicked = false
		click_confirmation.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_reintentar_pressed() -> void:  # Nombre de función corregido
	if not_clicked:
		not_clicked = false
		click_confirmation.play() 
		await get_tree().create_timer(0.5).timeout 
		get_tree().reload_current_scene() 

func _on_salir_a_menu_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()

func _on_salir_a_menu_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()

func _on_reintentar_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()

func _on_reintentar_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()

func on_game_over():
	final_score = score
	if final_score_label != null:
		final_score_label.text = "Score: " + str(final_score)  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
