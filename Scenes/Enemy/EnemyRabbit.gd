extends Enemy

var min_x = 0
var max_x = 1000
var min_y = -1000
var max_y = 0

var last_stop_moving_time = 0
var pause_delay = 5 # seconds

func _ready():
	super._ready()
	last_stop_moving_time = 0


func _process(delta):
	super._process(delta)
	velocity *= 0.7 * delta

		
func update_target_position():
	var curr_time = Time.get_ticks_msec()
	if curr_time - last_target_position_update > target_position_update_delay*1000:
		var targets = get_tree().get_nodes_in_group("EnemyTarget")
		if targets:
			target_position = targets[0]
			for t in targets:
				if global_position.distance_to(t.global_position) < global_position.distance_to(target_position):
					target_position = t.global_position
			last_target_position_update = curr_time
		elif velocity == Vector2(0, 0) and curr_time - last_stop_moving_time > pause_delay*1000:
			target_position = get_random_position()
			last_target_position_update = curr_time
		
		
func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	var dir = roundi(rad_to_deg(global_position.angle_to_point(target_position))/45)
		
	#setting animations depending on direction, can be used for other stuff
	match dir:
		0: #right
			$AnimatedSprite2D.play("side")
			$AnimatedSprite2D.flip_h = false
			#print("ayoooo")
		1: #bottomright
			$AnimatedSprite2D.play("bottomangle")
			$AnimatedSprite2D.flip_h = false
		2: #bottom
			$AnimatedSprite2D.play("down")
			$AnimatedSprite2D.flip_h = false
		3: #bottomleft
			$AnimatedSprite2D.play("bottomangle")
			$AnimatedSprite2D.flip_h = true
		4,-4: #left
			$AnimatedSprite2D.play("side")
			$AnimatedSprite2D.flip_h = true
		-3: #topleft
			$AnimatedSprite2D.play("topangle")
			$AnimatedSprite2D.flip_h = true
		-2: #top
			$AnimatedSprite2D.play("up")
			$AnimatedSprite2D.flip_h = false
		-1: #topright
			$AnimatedSprite2D.play("topangle")
			$AnimatedSprite2D.flip_h = false
	
	if move_and_collide(direction * speed * delta):
		has_collided = true
		target_position = get_random_position() # Immediately seek a new target upon collision
	elif global_position.distance_to(target_position) < 5:
		velocity = Vector2(0, 0)
	else:
		position += direction * speed * delta
		last_stop_moving_time = Time.get_ticks_msec()
		has_collided = false
	
	#if has_collided:
		#target_position = get_random_position()
	#elif global_position.distance_to(target_position) < 5:
		#velocity = Vector2(0, 0)
	#else:
		#position += direction * speed * delta
		#last_stop_moving_time = Time.get_ticks_msec(
	
	
func get_random_position():
	randomize()
	var new_position = Vector2()
	new_position.x = randi_range(min_x, max_x)
	new_position.y = randi_range(min_x, max_x)
	return new_position
