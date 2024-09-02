extends Area2D

var color = "red"

@export var red : Texture2D
@export var green : Texture2D
@export var purple : Texture2D

func _ready():
	match color:
		"red":
			$Sprite2D.texture = red
		"green":
			$Sprite2D.texture = green
		"purple":
			$Sprite2D.texture = purple

func _on_area_entered(area):
	if area.has_method("add_paint"):
		area.add_paint(3, color)
