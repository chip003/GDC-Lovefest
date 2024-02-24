extends Node2D


var target_position = Vector2()
var speed = 15


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
	position += direction * speed * delta
