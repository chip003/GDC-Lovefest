extends TextureRect

var selected = false
var data

func _process(delta):
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("rightclick"):
		toggle_select(null)
	
	if Input.is_action_just_pressed("leftclick"):
		var pots = $Area2D.get_overlapping_areas()
		if pots.size() > 0:
			var pot = pots[0].get_parent()
			print(pot)
			if data != null:
				if pot.currentPlant == null: 
					if data.Type == "Seed": #planting a new seed
						var plant = data.Scene.instantiate()
						pot.currentPlant = plant
						plant.global_position = pot.global_position
						get_parent().add_child(plant)
						get_node("/root/PlayArea").money -= data.Cost
				else:
					if data.Type == "Watering Can": #watering a plant
						pot.currentPlant.waterLevel = 1.0
						$Water.emitting = true
						get_node("/root/PlayArea").money -= data.Cost
						
					elif data == null: #pickup a plant
						pass
						#pot.currentPlant.followTarget = self
						#toggle_select()

func toggle_select(newData):
	data = newData
	if newData:
		selected = true
		Input.set_custom_mouse_cursor(newData.Sprite)
	else:
		Input.set_custom_mouse_cursor(null)
		selected = false
