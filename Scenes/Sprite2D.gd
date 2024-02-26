extends TextureRect

var selected = false

func _process(delta):
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("leftclick"):
		var pots = $Area2D.get_overlapping_areas()
		if pots.size() > 0:
			toggle_select(null)


func toggle_select(data):
	if data:
		selected = true
		Input.set_custom_mouse_cursor(data.Sprite)
	else:
		Input.set_custom_mouse_cursor(null)
		selected = false
