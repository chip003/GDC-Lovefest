extends CharacterBody2D

var target_position = Vector2()

var speed = 50

func _ready():
	pass


func _process(delta):
	update_target_position()
	move_towards_target(delta)
		
		
func update_target_position():
	var targets = get_tree().get_nodes_in_group("TestTarget")
	if targets.size() > 0:
		target_position = targets[0].position
		
		
func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	
	var dir = roundi(rad_to_deg(global_position.angle_to_point(target_position))/45)
		
	#setting animations depending on direction, can be used for other stuff
	match dir:
		0: #right
			$AnimatedSprite2D.play("side")
			$AnimatedSprite2D.flip_h = false
			print("ayoooo")
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
	
	position += direction * speed * delta
