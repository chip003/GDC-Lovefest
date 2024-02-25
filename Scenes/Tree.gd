extends Sprite2D

func _ready():
	if randi_range(0,1) == 0:
		flip_h = true
		
	scale *= randf_range(0.75,1.25)
