extends RigidBody2D

@export var brokensprite : Texture2D
@export var sprite : Texture2D
@export var painted : Texture2D
@export var painted_and_broken : Texture2D

var health = 5
var is_painted = false
var is_broken = false

func _ready():
	change_texture()
	gravity_scale = 0

func _on_body_entered(body : Node2D):
	var type = "hit"
	if body.has_method("get_type"):
		if body.get_type() == "paint":
			if !is_painted:
				body.painted()
				change_texture()
				is_painted = true
				get_node("/root/Main/UI").add_score(50)
	
	gravity_scale = 1
	
	if linear_velocity.length() > 5:
		health -= 1
		if health == 0:
			if !is_broken:
				$CollisionShape2D.disabled = true
				collision_layer = 4
				collision_mask = 2
				is_broken = true
				change_texture()
				get_node("/root/Main/UI").add_score(100)

func change_texture():
	if is_broken && is_painted:
		$Sprite2D.texture = painted_and_broken
	elif is_painted:
		$Sprite2D.texture = painted
	elif is_broken:
		$Sprite2D.texture = brokensprite
	else:
		$Sprite2D.texture = sprite
