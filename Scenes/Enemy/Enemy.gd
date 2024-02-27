class_name Enemy extends CharacterBody2D

var has_collided = false
var target_position = Vector2()
var last_target_position_update
var target_position_update_delay = 1 # seconds
var damage = 1
var speed = 50
var nursery

func _ready():
	var nodes = get_tree().get_nodes_in_group("PlayArea")
	if nodes:
		print('Enemy: successfully found Nursery')
		nursery = nodes[0]
	last_target_position_update = 0


func _process(delta):
	update_target_position()
	move_and_slide()
	move_towards_target(delta)
		
func update_target_position():
	var curr_time = Time.get_ticks_msec()
	if curr_time - last_target_position_update > target_position_update_delay*1000:
		var targets = get_tree().get_nodes_in_group("EnemyTarget")
		if targets:
			target_position = targets[0].global_position
			for t in targets:
				if global_position.distance_to(t.global_position) < global_position.distance_to(target_position):
					target_position = t.global_position
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
	
	if in_collision():
		velocity = direction
		if in_collision_with_plant():
			# damage plant
			pass
		else:
			nursery.nursery_hp -= 1 * delta
			#print("damaged nursery")
			#print(nursery.nursery_hp)
	else:
		position += direction * speed * delta
		
		
func in_collision():
	return get_slide_collision_count() > 0
	
	
func in_collision_with_plant():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Plant"):
			return collider.get_collider()
	return null
