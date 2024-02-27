extends Button

@export_multiline var desc = ""

@export var data = {
	"Name": "Rose",
	"Sprite": preload("res://Sprites/seed_rose.png"),
	"Scene": preload("res://Scenes/Plants/rose.tscn"),
	"Type": "Seed",
	"Cost": 10,
}

var main

func _ready():
	icon = data.Sprite
	tooltip_text = desc
	main = get_node("/root/PlayArea")


func _process(delta):
	if main.money >= data.Cost:
		disabled = false
	else:
		disabled = true


func _on_pressed():
	get_node("/root/PlayArea/Cursor").toggle_select(data)
