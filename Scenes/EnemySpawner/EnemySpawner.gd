extends Node

const MAX_ENEMY = 3
var last_spawn_time
var spawn_delay = 5 # seconds
var last_move_time
var move_delay = 10 # seconds
var enemy_file_paths = []
var enemy_instances = []
const enemy_file_path = "res://Scenes/Enemy/Enemy.tscn"

var min_x = -100
var max_x = 100
var min_y = -100
var max_y = 100


func _ready():
	last_spawn_time = Time.get_ticks_msec()
	last_move_time = Time.get_ticks_msec()

func _process(delta):
	var current_time = Time.get_ticks_msec()
	if current_time - last_spawn_time > spawn_delay*1000 and len(enemy_instances) < MAX_ENEMY:
		spawn_enemy()
		last_spawn_time = current_time
	if current_time - last_move_time*1000 > move_delay:
		move_spawner_to_random_position()
		last_move_time = current_time
	
	
func spawn_enemy():
	var enemy_scene = preload(enemy_file_path)
	var enemy_instance = enemy_scene.instantiate()
	get_tree().get_root().add_child(enemy_instance)
	enemy_instances.append(enemy_instance)


func move_spawner_to_random_position():
	# Randomly choose a side: 0 = top, 1 = bottom, 2 = left, 3 = right
	var side = randi() % 4
	var new_position = Vector2()
	match side:
		0: # Top
			new_position.x = randf_range(min_x, max_x)
			new_position.y = min_y
		1: # Bottom
			new_position.x = randf_range(min_x, max_x)
			new_position.y = max_y
		2: # Left
			new_position.x = min_x
			new_position.y = randf_range(min_y, max_y)
		3: # Right
			new_position.x = max_x
			new_position.y = randf_range(min_y, max_y)
	self.position = new_position
