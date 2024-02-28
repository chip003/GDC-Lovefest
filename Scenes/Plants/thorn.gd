extends Area2D

var direction = Vector2(0,0)
var damage = 1
var speed = 0.0

func _process(delta):
	global_position += direction*delta*speed
	$Sprite2D.rotation = direction.angle()


func _on_body_entered(body):
	if body is Enemy:
		body.currentHP -= damage
		queue_free()
