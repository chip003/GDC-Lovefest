extends StaticBody2D

## Time it takes to grow the plant
var growTime = 20.0 #seconds
## The progress of growth (0 is newborn, 1 is mature)
var growth = 0.0
## The current level of water (0 is dry, 1 is wet)
var waterLevel = 0.0
## The time it takes for the water to dry up
var dryTime = 10.0
## Maximum amount of health
@export var hp = 20.0
@onready var currentHP = hp
@export var attackTime = 1.0 #seconds
@onready var attackCooldown = attackTime
@export var projectileSpeed = 600.0
@export var projectileDamage = 1.0
@export var attackRange = 384
@export var canAttack = true

var followTarget = null
var placed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0,0)
	$HealthBar.max_value = hp
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar.value = currentHP
	
	if currentHP < hp:
		$HealthBar.visible = true
	else:
		$HealthBar.visible = false
	
	if followTarget:
		print(global_position)
		global_position = followTarget.global_position
	
	scale = Vector2(growth, growth)
	if waterLevel > 0:
		if growth < 1:
			growth += (1/growTime)*delta
	
		#print(str(waterLevel) + " " + str(growth))
	
		waterLevel -= (1/dryTime)*delta
		
	if placed: #code to be ran when plant is adult
		if canAttack:
			var enemies = get_tree().get_nodes_in_group("Enemy")
			var dist = INF
			var target = null
			
			for i in enemies:
				if global_position.distance_to(i.global_position) < dist:
					dist = global_position.distance_to(i.global_position)
					target = i
					
			if target:
				if dist < attackRange:
					if attackCooldown <= 0:
						$Shoot.pitch_scale = randf_range(0.75,1.25)
						$Shoot.play()
						var thorn = preload("res://Scenes/Plants/thorn.tscn").instantiate()
						thorn.global_position = global_position
						thorn.direction = global_position.direction_to(target.global_position)
						thorn.speed = projectileSpeed
						thorn.damage = projectileDamage
						get_parent().add_child(thorn)
						attackCooldown = attackTime
					else:
						attackCooldown -= 1*delta
		else:
			if attackCooldown <= 0:
				get_node("/root/PlayArea").money += 1
				attackCooldown = attackTime
			else:
				attackCooldown -= 1*delta
				
	if currentHP <= 0:
		queue_free()
