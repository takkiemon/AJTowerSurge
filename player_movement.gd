extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

@onready var test_gun_scene = preload("res://test_scenes/test_gun.tscn")
@onready var camera = get_node("Camera3D")

var forward = Vector3(1, 0, 0)
var target_velocity = Vector3.ZERO
var rayOrigin = Vector3.ZERO
var rayEnd = Vector3.ZERO
var _has_test_gun = false

# idk lmao
var space_state = null
var mouse_position = Vector2.ZERO
var params = PhysicsRayQueryParameters3D.new()
var intersection = PhysicsRayQueryParameters3D.new()
var pos = Vector3.ZERO

func _physics_process(_delta):
	_add_or_remove_gun()
	_move_player()
	_look_at_mouse()

func _move_player():
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		# Ground Velocity
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed

		# Moving the Character
		velocity = target_velocity
		move_and_slide()
	
func _add_or_remove_gun():
	if Input.is_action_pressed("add_or_remove_gun"):
		if !_has_test_gun:
			_has_test_gun = true
			var gun_instance := test_gun_scene.instantiate() as Node3D
			add_child(gun_instance)
			gun_instance.position = Vector3(1, 0, 0)
			gun_instance.name = "test_gun"
		else:
			_has_test_gun = false
			var test_gun = get_node("test_gun")
			test_gun.remove_child(test_gun)

func _look_at_mouse():
	#getting the current phyisics state
	space_state = get_world_3d().direct_space_state
	#getting the current mouse position
	mouse_position = get_viewport().get_mouse_position()

	rayOrigin = camera.project_ray_origin(mouse_position)

	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	params = PhysicsRayQueryParameters3D.new()
	params.from = rayOrigin
	params.to = rayEnd
	intersection = space_state.intersect_ray(params)
	
	# Somehow this crashes without the check. I'm not even sure it's ever true
	if intersection.has('position'): # OK, so the issue is that we only check for intersection with the player? Pretty sure I'm trying to find intersection with the screen or the ground or something
		print("YES intersect")
		pos = intersection["position"]
		forward = Vector3(pos.x, pos.y, pos.z)
	#rotation = forward
	#rotation = forward.angle_to()
		rotation = forward
	else:
		print("NO intersect")
