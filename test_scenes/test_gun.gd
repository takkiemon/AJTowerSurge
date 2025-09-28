extends Node3D

@onready var bullet_scene = preload("res://test_scenes/test_bullet.tscn")
@export var fire_rate = 1
@export var firing_timer = 0
@export var shooting_speed = 30
@export var _bullet_hole : Node3D
var forward = Vector3.ZERO

func _physics_process(delta):
	_shoot_bullet(delta)
	
func _shoot_bullet(delta):
	if Input.is_action_pressed("shoot_test_bullet"):
		firing_timer += delta
		
		if (firing_timer <= fire_rate):
			return
			
		var amount_of_bullets = int(firing_timer / fire_rate)
		firing_timer -= amount_of_bullets * fire_rate
		
		for i in range(amount_of_bullets):
			forward = _bullet_hole.position
			var instance := bullet_scene.instantiate() as Node3D
			instance.global_position = _bullet_hole.global_position
			instance.set_shooting_variables(shooting_speed, forward)
			var world_node = get_tree().root.get_child(0)
			world_node.add_child(instance)
	else:
		firing_timer += delta
		if (firing_timer > fire_rate):
			firing_timer = fire_rate
