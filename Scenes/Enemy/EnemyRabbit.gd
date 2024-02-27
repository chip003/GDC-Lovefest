extends CharacterBody2D

var has_collided = false
var target_position = Vector2()
var last_target_position_update
var target_position_update_delay = 1 # seconds
var damage = 1
var speed = 75
var nursery

var min_x = 0
var max_x = 1000
var min_y = -1000
var max_y = 0

var last_stop_moving_time = 0
var pause_delay = 5 # seconds

func _ready():
	var nodes = get_tree().get_nodes_in_group("PlayArea")
	if nodes:
		print('Enemy: successfully found Nursery')
		nursery = nodes[0]
	last_target_position_update = 0
	last_stop_moving_time = 0


func _process(delta):
	has_collided = false
	update_target_position()
	move_and_slide()
	move_towards_target(delta)
	has_collided = in_collision()
		
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
	
	if has_collided:
		target_position = get_random_position()
	elif global_position.distance_to(target_position) < 5:
		velocity = Vector2(0, 0)
	else:
		#print("moving")
		position += direction * speed * delta
		last_stop_moving_time = Time.get_ticks_msec()
		
		
func in_collision():
	return get_slide_collision_count() > 0
	
func in_collision_with_plant():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#if collision.get_collider().name == "Plant?":
			#return true
	return false
	
func get_random_position():
	randomize()
	var new_position = Vector2()
	new_position.x = randi_range(min_x, max_x)
	new_position.y = randi_range(min_x, max_x)
	return new_position
