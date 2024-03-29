extends Camera2D

var speed = 1000

func _ready():
	#limit_left = get_parent().limitMin.x
	#limit_right = get_parent().limitMax.x
	#limit_top = get_parent().limitMin.y
	#limit_bottom = get_parent().limitMax.y
	pass
func _process(delta):
	var moveVector = Input.get_vector("left", "right", "up", "down")
	
	global_position = (global_position+(moveVector*speed*delta)).clamp(get_parent().limitMin/1.75,get_parent().limitMax/1.75)

	if Input.is_action_just_pressed("scrollin"):
		if zoom.x < 1.5:
			zoom *= 1.08
		
	if Input.is_action_just_pressed("scrollout"):
		if zoom.x > 0.75:
			zoom /= 1.08
