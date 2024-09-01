extends StaticBody2D

@export var mop : Texture2D
@export var mop_painted : Texture2D

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

func add_paint(num):
	paint = num
	if paint > 0:
		$Sprite2D.texture = mop_painted
