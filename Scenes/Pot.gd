extends Node2D

var currentPlant = null

func _process(delta):
	$Water.emitting = false
	
	if currentPlant != null:
		if currentPlant.waterLevel > 0:
			$Water.emitting = true
