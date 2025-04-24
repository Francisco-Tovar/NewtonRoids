extends Node2D
@onready var musica: AudioStreamPlayer2D = $Musica

func _ready() -> void:
	musica.play()

func _process(_delta):
	#debug actions esc=quit f1=reset
	if	Input.is_action_just_pressed("quit"):
		Score.restart()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	elif Input.is_action_just_pressed("reset"):
		Score.restart()		
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("die"):
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
