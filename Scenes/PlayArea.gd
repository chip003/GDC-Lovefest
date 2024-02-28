extends Node2D

var limitMin = Vector2i(-1024,-1024)
var limitMax = Vector2i(1024,1024)

var money = 40
var nursery_hp = 200
var time = 0.0

func _process(delta):
	time += 1*delta
	$CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Gold/Label.text = str(money)
	var seconds = "%02d" % floor(fmod(time,60))
	if nursery_hp > 0:
		$CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Day/Label.text = str(floor(time/60)) + ":" + seconds
	
	$CanvasLayer/Top/Label.text = str(floor(nursery_hp))
	$CanvasLayer/Top/ProgressBar.value = nursery_hp
	
	if nursery_hp <= 0:
		$CanvasLayer/Lose.visible = true
	
func _ready():
	$CanvasLayer/Top/ProgressBar.max_value = nursery_hp
	spawn_horizontal(Vector2(limitMin.x,limitMax.x),limitMin.y)
	spawn_horizontal(Vector2(limitMin.x,limitMax.x),limitMax.y)
	
	spawn_vertical(Vector2(limitMin.y,limitMax.y),limitMin.x)
	spawn_vertical(Vector2(limitMin.y,limitMax.y),limitMax.x)
	
	add_to_group("PlayArea")


func spawn_horizontal(xrange, ylevel):
	for i in range(50):
		var tree = preload("res://Scenes/tree.tscn").instantiate()
		tree.global_position = Vector2(randf_range(xrange.x,xrange.y), randf_range(ylevel-256,ylevel+256))
		add_child(tree)


func spawn_vertical(yrange, xlevel):
	for i in range(50):
		var tree = preload("res://Scenes/tree.tscn").instantiate()
		tree.global_position = Vector2(randf_range(xlevel-256,xlevel+256), randf_range(yrange.x,yrange.y))
		add_child(tree)


func _on_button_pressed():
	get_tree().reload_current_scene()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
