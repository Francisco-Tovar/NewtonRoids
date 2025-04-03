extends Area2D
@onready var sp1: Sprite2D = $Sprite2D2
@onready var sp2: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
#spin effect
	sp1.rotation_degrees += 15 * delta;	
	sp2.rotation_degrees -= 15 * delta;
	
	
#size variant effect
	var ran = randf_range(-0.001 , 0.001);
	var sx = sp1.scale.x + ran;
	sp1.scale.x = clamp( sx, 0.85, 1.15 );
	var sy = sp1.scale.x + ran;
	sp1.scale.y = clamp( sy, 0.85, 1.15 );	
	var ssx = sp2.scale.x + ran;
	sp2.scale.x = clamp( ssx, 0.45, 0.75 );
	var ssy = sp2.scale.x + ran;
	sp2.scale.y = clamp( ssy, 0.45, 0.75 );
