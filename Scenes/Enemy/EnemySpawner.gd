extends Node2D


const MAX_ENEMY = 3
var last_spawn_time
var spawn_delay = 10 # seconds
var last_move_time
var move_delay = 3 # seconds
var enemy_file_paths = []
var enemy_instances = []
const enemy_file_path = "res://Scenes/Enemy/Enemy.tscn"
var min_x = 0
var max_x = 1000
var min_y = -1000
var max_y = 0


func _ready():
	last_spawn_time = Time.get_ticks_msec()
	last_move_time = Time.get_ticks_msec()


func _process(delta):
	var current_time = Time.get_ticks_msec()
	if time_to_spawn(current_time) and not enemy_capacity_reached():
		spawn_enemy()
		last_spawn_time = current_time
	if time_to_move(current_time):
		move_spawner_to_random_position()
		last_move_time = current_time
	
	
func enemy_capacity_reached():
	return len(enemy_instances) >= MAX_ENEMY
	
	
func time_to_move(current_time):
	return current_time - last_move_time > move_delay*1000
	
	
func time_to_spawn(current_time):
	return current_time - last_spawn_time > spawn_delay*1000
	
	
func spawn_enemy():
	var enemy_scene = preload(enemy_file_path)
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = global_position
	get_tree().get_root().add_child(enemy_instance)
	enemy_instances.append(enemy_instance)


func move_spawner_to_random_position():
	# Randomly choose a side: 0 = top, 1 = bottom, 2 = left, 3 = right
	randomize()
	var side = randi() % 4
	var new_position = Vector2()
	match side:
		0: # Top
			new_position.x = randi_range(min_x, max_x)
			new_position.y = min_y
		1: # Bottom
			new_position.x = randi_range(min_x, max_x)
			new_position.y = max_y
		2: # Left
			new_position.x = min_x
			new_position.y = randi_range(min_y, max_y)
		3: # Right
			new_position.x = max_x
			new_position.y = randi_range(min_y, max_y)
	global_position = new_position
