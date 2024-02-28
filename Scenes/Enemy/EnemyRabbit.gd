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

		
#func update_target_position():
	#var curr_time = Time.get_ticks_msec()
	#if curr_time - last_target_position_update > target_position_update_delay*1000:
		#var targets = get_tree().get_nodes_in_group("EnemyTarget")
		#if targets:
			#target_position = targets[0]
			#for t in targets:
				#if global_position.distance_to(t.global_position) < global_position.distance_to(target_position):
					#target_position = t.global_position
			#last_target_position_update = curr_time
		#elif velocity == Vector2(0, 0) and curr_time - last_stop_moving_time > pause_delay*1000:
			#target_position = get_random_position()
			#last_target_position_update = curr_time
		
		
func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	var dir = roundi(rad_to_deg(global_position.angle_to_point(target_position))/45)
	
	if move_and_collide(direction * speed * delta):
		has_collided = true
		target_position = get_random_position() # Immediately seek a new target upon collision
	elif global_position.distance_to(target_position) < 5:
		velocity = Vector2(0, 0)
	else:
		position += direction * speed * delta
		last_stop_moving_time = Time.get_ticks_msec()
		has_collided = false
