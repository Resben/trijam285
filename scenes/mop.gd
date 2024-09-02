extends Area2D

@export var mop : Texture2D
@export var mop_green : Texture2D
@export var mop_purple : Texture2D
@export var mop_red : Texture2D

var paint = 0

func get_type():
	if paint > 0:
		return "paint"
	else:
		return "hit"

func painted():
	if paint > 0:
		paint -= 1
	
	if paint == 0:
		$Sprite2D.texture = mop

func add_paint(num, color):
	paint = num
	if paint > 0:
		match color:
			"green":
				$Sprite2D.texture = mop_green
			"purple":
				$Sprite2D.texture = mop_purple
			"red":
				$Sprite2D.texture = mop_red

