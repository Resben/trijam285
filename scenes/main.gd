extends Node2D

var current_distance = 0
var distance_to_next_spawn = 0
var distance_to_next_paint = 0

var destroyable = preload("res://scenes/destroyable.tscn") as PackedScene
var paint = preload("res://scenes/paint_bucket.tscn") as PackedScene

var items = [
	preload("res://resources/p1.tres"),
	preload("res://resources/p2.tres")
]

var colors = [
	"red", "green", "purple"
]

func _ready()->void:
	current_distance = $Player.global_position.x
	
	var modification_stack: SkeletonModificationStack2D = $"Player".get_modification_stack()
	# Better to enable it at runtime as it makes it harder to interact with in the editor when on
	modification_stack.enabled = true
	
	var modification_physical_bones = modification_stack.get_modification(0)
	modification_physical_bones.enabled = true
	
	fix_skeleton($Player)
	
	modification_physical_bones.fetch_physical_bones()
	# this will enable simulate_physics on all bones
	modification_physical_bones.start_simulation()
	
	# if you call stop_simulation() then start_simulation() again it will break until you freeze and unfreeze each bone
	modification_physical_bones.stop_simulation()
	modification_physical_bones.start_simulation()
	fix_skeleton($Player)

func fix_skeleton(target: Skeleton2D):
	for child in target.get_children():
		if child is PhysicalBone2D:
			call_child_recursive(child, update_bone)

func call_child_recursive(node: Node2D, f: Callable):
	f.call(node)
	for child in node.get_children():
		call_child_recursive(child, f)

func update_bone(bone: Node2D):
	if bone is PhysicalBone2D:
		if !bone.simulate_physics:
			# there might be yet another bug regarding the resulting position of bone and its children after enabling simulate_physics
			# recommended to check it in the editor and ensure the position is correct
			print("warning: " + bone.name + " simulate_physics is not checked!")
		# this will undo the cpp constructor
		bone.freeze = true
		bone.freeze = false

func _process(delta):
	$Ground.global_position.x = $Player/Hip.global_position.x
	
	if $Player/Hip.global_position.x > current_distance:
		current_distance = $Player/Hip.global_position.x
		if distance_to_next_spawn < current_distance:
			var o = destroyable.instantiate() as RigidBody2D
			
			var rand_item = randi_range(0, items.size() - 1)
			o.data = items[rand_item]
			
			add_child(o)
			o.global_position = Vector2($Player/Hip.global_position.x + 1400, randi_range(250, 600))
			distance_to_next_spawn = current_distance + randi_range(150, 600)
			
		if distance_to_next_paint < current_distance:
			var o = paint.instantiate() as Area2D
			
			var rand_item = randi_range(0, colors.size() - 1)
			o.color = colors[rand_item]
			
			add_child(o)
			o.global_position = Vector2($Player/Hip.global_position.x + 1400, randi_range(560, 630))
			distance_to_next_paint = current_distance + randi_range(2000, 2500)
	
	if Input.is_action_just_pressed("test"):
		$UI.add_score(50)
	
	
