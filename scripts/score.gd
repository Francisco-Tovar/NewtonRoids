extends Control
@onready var score_label: Label = $scoreLabel

var score = 0

func restart():
	score = 0

func get_score() -> int:
	return score

func _process(delta: float) -> void:
	score_label.text = str(score)

func update_score(points: int):	
	score += points
