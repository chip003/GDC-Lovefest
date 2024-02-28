class_name Enemy extends CharacterBody2D

var has_collided = false
var target_position = Vector2(0,0)

## Time it takes to find a new target after reaching the current one
var target_search_time = 1.0 # seconds
var current_target_search_time = 0.0

@export var damage = 1
@export var speed = 50
@export var hp = 4.0
@onready var currentHP = hp

@export var targetPlants = false

@onready var root = get_node("/root/PlayArea")

func _ready():
	if targetPlants:
		target_position = get_new_target_position()
	

func _process(delta):
	move_towards_target(delta)
	
	
func get_random_position(): #returns random position within boundries defined in playarea
	return Vector2(randf_range(root.limitMin.x,root.limitMax.x), randf_range(root.limitMin.y,root.limitMax.y))
	
	
func get_new_target_position():
	var dist = INF
	var targets = get_tree().get_nodes_in_group("Plant")
	var targetPosition = get_random_position()
	var targetPlant = null
	
	# Find the closest plant to target
	for i in targets:
		if i.placed:
			if global_position.distance_to(i.global_position) < dist:
				dist = global_position.distance_to(i.global_position)
				targetPlant = i
		
	#there is at least one plant to target
	if targetPlant:
		targetPosition = targetPlant.global_position
		
	return targetPosition


func move_towards_target(delta): 
	var direction = global_position.direction_to(target_position)
	var dir = roundi(rad_to_deg(global_position.angle_to_point(target_position))/45)
	
	#setting animations depending on direction, can be used for other stuff
	match dir:
		0: #right
			$AnimatedSprite2D.play("side")
			$AnimatedSprite2D.flip_h = false
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
	
	var collision = move_and_collide(direction, true)
	
	if collision: #colliding with object
		velocity = Vector2(0,0)
		
		if collision.get_collider().is_in_group("Plant") && collision.get_collider().placed: #damage plant
			collision.get_collider().currentHP -= 2 * delta
		else: #damage nursery
			if !targetPlants: #regular enemies
				root.nursery_hp -= 1 * delta
			else: #only attacks plants
				if current_target_search_time <= 0:
					current_target_search_time = target_search_time
					target_position = get_new_target_position()
				else:
					current_target_search_time -= (1/target_search_time)*delta
	else:
		if global_position.distance_to(target_position) > 0.1:
			velocity = direction*speed
		else:
			velocity = Vector2(0,0)
			if current_target_search_time <= 0:
				current_target_search_time = target_search_time
				target_position = get_new_target_position()
			else:
				current_target_search_time -= (1/target_search_time)*delta	
	
	if currentHP <= 0:
		root.money += 2
		queue_free()
	
	move_and_slide()
