extends HBoxContainer

@onready var bar: AnimatedSprite2D = $AnimatedSprite2D


func update_pbar(power: int):	
	var realPower = int(power)
	if realPower < 1:
		realPower = 1
	if realPower > 4: 
		realPower = 4
	if power == 0:
		realPower = 0
	bar.frame = realPower
