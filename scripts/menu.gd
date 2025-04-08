extends Control
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic

func _ready() -> void:
	menu_music.play()

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
