extends RigidBody2D

@export var data : ItemData

var health = 5
var is_painted = false
var is_broken = false

func _ready():
	change_texture()
	gravity_scale = 0

func _on_body_entered(body : Node2D):
	var type = "hit"
	if body.has_method("is_mop"):
		if body.p.get_type() == "paint":
			print("here")
			if !is_painted:
				body.p.painted()
				is_painted = true
				change_texture()
				get_node("/root/Main/UI").add_score(50)
	
	gravity_scale = 1
	
	if linear_velocity.length() > 5:
		health -= 1
		if health == 0:
			if !is_broken:
				collision_layer = 4
				collision_mask = 2
				is_broken = true
				change_texture()
				get_node("/root/Main/UI").add_score(100)

func change_texture():
	if is_broken && is_painted:
		$Sprite2D.texture = data.broken_painted
	elif is_painted:
		$Sprite2D.texture = data.painted
	elif is_broken:
		$Sprite2D.texture = data.broken
	else:
		$Sprite2D.texture = data.normal
