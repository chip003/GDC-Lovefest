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
var hp = 10.0
var currentHP = hp

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
		else: #code to be ran when plant is adult
			pass
	
		#print(str(waterLevel) + " " + str(growth))
	
		waterLevel -= (1/dryTime)*delta
