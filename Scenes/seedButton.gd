extends Button

@export_multiline var desc = ""

@export var data = {
	"Name": "Rose",
	"Sprite": preload("res://Sprites/seed_rose.png"),
}


func _ready():
	icon = data.Sprite
	tooltip_text = desc


func _on_pressed():
	get_node("/root/PlayArea").select_seed(data)
