extends HBoxContainer
@onready var life: TextureRect = $life
@onready var life2: TextureRect = $life2
@onready var life3: TextureRect = $life3

var lives = 3

func DrawLives():	
	if lives == 3:
		life.visible = true
		life2.visible = true
		life3.visible = true
	
	if lives < 3:
		life3.visible = false
	
	if lives < 2:
		life2.visible = false
	
	if lives < 1:
		life.visible = false

func SetLives(x: int):
	lives = x
