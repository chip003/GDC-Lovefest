extends TextureRect

var selected = false
var data
var holdingPlant = false
var currentPot = null

func _process(delta):
	global_position = get_global_mouse_position()
	
	if data:
		if get_node("/root/PlayArea").money < data.Cost:
			toggle_select(null)
	
	if holdingPlant:
		if Input.is_action_just_pressed("leftclick"):
			if $CollisionCheck.get_overlapping_bodies().size() == 0:
				print("all good")
				holdingPlant = false
				currentPot.currentPlant.followTarget = null
				currentPot.currentPlant.placed = true
				currentPot.currentPlant = null
				currentPot = null
				
	
		if Input.is_action_just_pressed("rightclick"):
			currentPot.currentPlant.followTarget = currentPot
			holdingPlant = false
			currentPot = null
	else:
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
					else: #plant does exist
						if data.Type == "Watering Can": #watering a plant
							pot.currentPlant.waterLevel = 1.0
							$Water.restart()
							$Water.emitting = true
							get_node("/root/PlayArea").money -= data.Cost
							
				else:
					if pot.currentPlant: #pickup a plant
						if pot.currentPlant.growth >= 1:
							if !pot.currentPlant.placed:
								pot.currentPlant.followTarget = self
								currentPot = pot
								holdingPlant = true
				
				
	
func toggle_select(newData):
	data = newData
	if newData:
		selected = true
		Input.set_custom_mouse_cursor(newData.Sprite)
	else:
		Input.set_custom_mouse_cursor(null)
		selected = false
