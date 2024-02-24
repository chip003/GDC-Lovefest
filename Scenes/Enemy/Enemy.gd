extends Node2D

var target
var target_position = Vector2() # Target's position
var speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_target_position()
	move_towards_target(delta)
		
		
func update_target_position():
	var targets = get_tree().get_nodes_in_group("TestTarget")
	if targets.size() > 0:
		target_position = targets[0].position
		
func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	position += direction * speed * delta
