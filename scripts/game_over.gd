extends Control
@onready var mouse_over: AudioStreamPlayer2D = $mouseOver
@onready var mouse_off: AudioStreamPlayer2D = $mouseOff
@onready var final_score_label: RichTextLabel = $CanvasLayer/ScoreLabel/ScoreLabelValue
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic

var not_clicked = true
var score = 0

func _ready() -> void:
	menu_music.play()
	score = Score.get_score()
	if final_score_label != null:
		print("Score: " + str(score))
		final_score_label.text =  str(score)  

func _on_reintentar_pressed() -> void:  # Nombre de función corregido
	if not_clicked:
		Score.restart()
		not_clicked = false
		Clickconfirmation.play()
		await get_tree().create_timer(0.5).timeout 		
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_reintentar_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()

func _on_reintentar_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()


func _on_salir_pressed() -> void:
	if not_clicked:
		not_clicked = false
		Clickconfirmation.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().quit()

func _on_salir_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()

func _on_salir_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()
