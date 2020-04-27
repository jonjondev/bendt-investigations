extends KinematicBody

onready var ray_cast_group = $RayCasts
onready var ray_casts = $RayCasts.get_children()
var move_speed = 0.05
var gravity = Vector3(0, -10, 0)
var velocity = Vector3()
var extent_offset = 0.25

func _physics_process(delta):
	var move = Vector3.ZERO
	if Input.is_action_pressed("ui_left"):
		move.x = -1
	if Input.is_action_pressed("ui_up"):
		move.z = -1
	if Input.is_action_pressed("ui_right"):
		move.x = 1
	if Input.is_action_pressed("ui_down"):
		move.z = 1
	
	move = move.normalized() * move_speed
	translation = translation + get_valid_move(move)
	
	velocity += gravity * delta 
	velocity = move_and_slide(velocity)

func get_valid_move(move):
	if is_on_surface(move):
		return move
	elif is_on_surface(Vector3(move.x, 0, 0)):
		return Vector3(move.x, 0, 0)
	elif is_on_surface(Vector3(0, 0, move.z)):
		return Vector3(0, 0, move.z)
	return Vector3.ZERO

func is_on_surface(potential_translation):
	ray_cast_group.translation = potential_translation
	for ray in ray_casts:
		ray.force_raycast_update()
		if not ray.get_collider():
			return false
	return true
