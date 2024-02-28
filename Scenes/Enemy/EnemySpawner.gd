extends Node

const MAX_ENEMY = 300
var spawn_delay = 10.0 # seconds
var current_spawn_delay = spawn_delay

const enemy_worm = "res://Scenes/Enemy/EnemyWorm.tscn"
const enemy_rabbit = "res://Scenes/Enemy/EnemyRabbit.tscn"
const enemy_aphid = "res://Scenes/Enemy/EnemyAphid.tscn"

@onready var main = get_node("/root/PlayArea")

var min_x = 0
var max_x = 1000
var min_y = -1000
var max_y = 0

var spawnCount = 1


func _ready():
	min_x = get_parent().limitMin.x
	max_x = get_parent().limitMax.x
	min_y = get_parent().limitMin.y
	max_y = get_parent().limitMax.y


func _process(delta):
	if current_spawn_delay <= 0:
		current_spawn_delay = spawn_delay
		spawn_enemy()
	else:
		current_spawn_delay -= 1*delta

	
func spawn_enemy():
	spawnCount += 0.2
	
	if spawn_delay > 2:
		spawn_delay -= 0.25
	
	for i in range(floor(spawnCount)):	
		randomize()
		var random_num = randi_range(0, 100)
		var enemy_scene
		if random_num < 25:
			enemy_scene = preload(enemy_rabbit).instantiate()
		elif random_num < 50 && main.time > 60:
			enemy_scene = preload(enemy_aphid).instantiate()
		else:
			enemy_scene = preload(enemy_worm).instantiate()
		enemy_scene .position = get_random_position()
		get_parent().add_child(enemy_scene)
		print("EnemySpawner: spawned enemy")


func get_random_position():
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
			new_position.y = randf_range(min_y, max_y)
			
	return new_position
