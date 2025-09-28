extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var fire_rate = .2
var firing_timer = 0

@onready var bullet_scene = preload("res://test_scenes/test_bullet.tscn")
@onready var camera = get_node("Camera3D")

var forward = Vector3(1, 0, 0)
var target_velocity = Vector3.ZERO
var rayOrigin = Vector3.ZERO
var rayEnd = Vector3.ZERO

func _physics_process(delta):
	_move_player()
	_look_at_mouse()
	_shoot_bullet(delta)

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
		# Setting the basis property will affect the rotation of the node.
		#$Pivot.basis = Basis.looking_at(direction)
		
		# Ground Velocity
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed

		# Moving the Character
		velocity = target_velocity
		move_and_slide()
	
func _look_at_mouse():
	#gettign the current phyisics state
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
	
func _shoot_bullet(delta):
	if Input.is_action_pressed("shoot_test_bullet"):
		firing_timer += delta
		if (firing_timer <= fire_rate):
			return
		var amount_of_bullets = int(firing_timer / fire_rate)
		firing_timer -= amount_of_bullets * fire_rate
		for i in range(amount_of_bullets):
			var instance := bullet_scene.instantiate() as Node3D
			
			instance.global_position = position
			instance.set_shooting_variables(10, forward)
			add_sibling(instance)
	else:
		firing_timer += delta
		if (firing_timer > fire_rate):
			firing_timer = fire_rate
