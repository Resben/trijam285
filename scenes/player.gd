extends Skeleton2D
class_name Player

@onready var hip = $PB_Hip
@onready var left_leg = $PB_Hip/PB_LeftThigh
@onready var right_leg = $PB_Hip/PB_RightThigh

var min_rotation = deg_to_rad(-90)
var max_rotation = deg_to_rad(90)

var state = "falling"
var last_state = "falling"

var leg = false
var direction_change = false

func _physics_process(delta):
	
	$Target.global_position = get_global_mouse_position()
	
	if Input.is_action_pressed("left"):
		var boost = 1.0
		if direction_change:
			direction_change = false
			boost = 5.0
		hip.linear_velocity += Vector2(-100, 0) * delta* boost
		left_leg.linear_velocity += Vector2(-randi_range(25, 100), 0) * delta * boost
		right_leg.linear_velocity += Vector2(-randi_range(25, 100), 0) * delta * boost
		rotate_leg(delta)
	if Input.is_action_pressed("right"):
		var boost = 1.0
		if !direction_change:
			direction_change = true
			boost = 5.0
		hip.linear_velocity += Vector2(100, 0) * delta * boost
		left_leg.linear_velocity += Vector2(randi_range(25, 100), 0) * delta * boost
		right_leg.linear_velocity += Vector2(randi_range(25, 100), 0) * delta * boost
		rotate_leg(delta)
	
	stablise_leg(left_leg, delta)
	stablise_leg(right_leg, delta)
	
	var distance = abs(hip.global_position.y - 532)
	var scale_value = distance / 50 + 1
	
	if hip.global_position.y > 536:
		hip.constant_force += Vector2(0, -600) * delta * scale_value
		left_leg.constant_force += Vector2(0, 75) * delta * scale_value
		right_leg.constant_force += Vector2(0, 75) * delta * scale_value
		last_state = state
		state = "falling"
	elif hip.global_position.y > 532:
		hip.constant_force = Vector2(0, -11)
		left_leg.constant_force = Vector2(0, 10)
		right_leg.constant_force = Vector2(0, 10)
		last_state = state
		state = "stable"
	else:
		hip.constant_force += Vector2(0, -75) * delta * scale_value
		left_leg.constant_force += Vector2(0, 600) * delta * scale_value
		right_leg.constant_force += Vector2(0, 600) * delta * scale_value
		last_state = state
		state = "standing up"
	
	if last_state != state:
		#print("switched from (" + last_state + ") to (" + state + ")")
		pass

func rotate_leg(delta):
		if leg:
			left_leg.angular_velocity += 5 * delta
			right_leg.angular_velocity += -5 * delta
			if left_leg.rotation_degrees > 45 || right_leg.rotation_degrees < -45:
				leg = !leg
		else:
			left_leg.angular_velocity += -5 * delta
			right_leg.angular_velocity += 5 * delta
			if left_leg.rotation_degrees < -45 || right_leg.rotation_degrees > 45:
				leg = !leg

func stablise_leg(bone : PhysicalBone2D, delta):
	if bone.rotation_degrees > 5:
		bone.angular_velocity += -1 * delta
	elif bone.rotation_degrees < -5:
		bone.angular_velocity += 1 * delta
