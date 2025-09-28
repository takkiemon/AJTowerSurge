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
	print("checking ADD||RMV-GUN...")
	if Input.is_action_pressed("add_or_remove_gun"):
		print("PRESS ADD||RMV-GUN")
		if !_has_test_gun:
			_has_test_gun = true
			print("ADD GUN START")
			var gun_instance := test_gun_scene.instantiate() as Node3D
			add_child(gun_instance)
			gun_instance.position = Vector3(1, 0, 0)
			gun_instance.name = "test_gun"
			print("ADD GUN END")
		else:
			_has_test_gun = false
			print("RMV GUN START")
			var test_gun = get_node("test_gun")
			test_gun.remove_child(test_gun)
			print("RMV GUN END")

func _look_at_mouse():
	#getting the current phyisics state
	var space_state = get_world_3d().direct_space_state
	#getting the current mouse position
	var mouse_position = get_viewport().get_mouse_position()

	rayOrigin = camera.project_ray_origin(mouse_position)

	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var params = PhysicsRayQueryParameters3D.new()
	params.from = rayOrigin
	params.to = rayEnd
	var intersection = space_state.intersect_ray(params)

	var pos = intersection.position
	forward = Vector3(pos.x, 0, pos.z)
	#rotation = forward
	rotation = forward.angleto
