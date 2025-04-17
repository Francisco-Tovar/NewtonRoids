extends Control
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
@onready var mouse_over: AudioStreamPlayer2D = $mouseOver
@onready var mouse_off: AudioStreamPlayer2D = $mouseOff

var not_clicked = true

func _ready() -> void:
	menu_music.play()

func _on_jugar_pressed() -> void:	
	if not_clicked:
		not_clicked = false
		Clickconfirmation.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_salir_pressed() -> void:	
	if not_clicked:
		not_clicked = false
		Clickconfirmation.play()
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()


func _on_jugar_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()


func _on_jugar_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()


func _on_salir_mouse_entered() -> void:
	if not_clicked:
		mouse_over.play()


func _on_salir_mouse_exited() -> void:
	if not_clicked:
		mouse_off.play()
