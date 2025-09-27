extends Node3D

@export var speed = 2

func _physics_process(delta):
	var target_velocity = Vector3(1, 0, 0)
	position += target_velocity * delta
