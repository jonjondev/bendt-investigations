extends KinematicBody

var move_speed: float = 0.05
var extent_offset: float = 0.25
var gravity: Vector3 = Vector3(0, -10, 0)
var velocity: Vector3 = Vector3.ZERO

onready var ray_cast_group: Spatial = $RayCasts
onready var ray_casts: Array = $RayCasts.get_children()

func _physics_process(delta) -> void:
	var move: Vector3 = Vector3.ZERO
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
	
	var initial_transform: Transform = $MeshInstance.get_transform()
	var final_transform: Transform = Transform(initial_transform.basis, $MeshInstance.translation + move)
	if initial_transform != final_transform:
		var rotated_transform: Transform = initial_transform.looking_at(final_transform.origin, Vector3.UP)
		var rotated_quat: Quat = Quat(initial_transform.basis).slerp(rotated_transform.basis, delta*5)
		$MeshInstance.set_transform(Transform(rotated_quat, initial_transform.origin))
	
	velocity += gravity * delta 
	velocity = move_and_slide(velocity)


func get_valid_move(move: Vector3) -> Vector3:
	if is_on_surface(move):
		return move
	elif is_on_surface(Vector3(move.x, 0, 0)):
		return Vector3(move.x, 0, 0)
	elif is_on_surface(Vector3(0, 0, move.z)):
		return Vector3(0, 0, move.z)
	return Vector3.ZERO


func is_on_surface(potential_translation: Vector3) -> bool:
	ray_cast_group.translation = potential_translation
	for ray in ray_casts:
		ray.force_raycast_update()
		if not ray.get_collider():
			return false
	return true
