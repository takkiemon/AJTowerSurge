extends Node3D

@export var speed = 5
var shooting_direction = Vector3(1, 0, 0)

func _physics_process(delta):
	var target_velocity = shooting_direction.normalized() * speed
	position += target_velocity * delta

func set_shooting_variables(number, direction):
	speed = number
	shooting_direction = direction
