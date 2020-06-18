extends KinematicBody

var walk_speed: float = 0.03
var run_speed: float = 0.07
var gravity: Vector3 = Vector3(0, -10, 0)
var velocity: Vector3 = Vector3.ZERO

onready var ray_cast_group: Spatial = $"../RayCasts"
onready var ray_casts: Array = ray_cast_group.get_children()
onready var anim_state_machine: AnimationNodeStateMachinePlayback = $Character/AnimationTree["parameters/playback"]

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
	
	ray_cast_group.translation = translation
	move = move.normalized() * (run_speed if Input.is_action_pressed("shift") else walk_speed)
	translation = translation + get_valid_move(move)
	
	var initial_transform: Transform = get_transform()
	var final_transform: Transform = Transform(initial_transform.basis, translation + move)
	if initial_transform != final_transform:
		var rotated_transform: Transform = initial_transform.looking_at(final_transform.origin, Vector3.UP)
		var rotated_quat: Quat = Quat(initial_transform.basis).slerp(rotated_transform.basis, delta*5)
		set_transform(Transform(rotated_quat, initial_transform.origin))
	
	velocity += gravity * delta 
	velocity = move_and_slide(velocity)
	
	var anim: String = "idle"
	if move.length() > 0:
	  anim = "walk"
	if anim != "idle" and Input.is_action_pressed("shift"):
		anim = "run"
	anim_state_machine.travel(anim)


func get_valid_move(move: Vector3) -> Vector3:
	var valid_move = Vector3.ZERO
	if is_on_surface(move):
		valid_move = move
	elif is_on_surface(Vector3(move.x, 0, 0)):
		valid_move = Vector3(move.x, 0, 0)
	elif is_on_surface(Vector3(0, 0, move.z)):
		valid_move = Vector3(0, 0, move.z)
	return valid_move


func is_on_surface(potential_translation: Vector3) -> bool:
	ray_cast_group.translation = ray_cast_group.translation + potential_translation
	var on_surface: bool = true
	for ray in ray_casts:
		ray.force_raycast_update()
		if not ray.get_collider():
			on_surface = false
			break
	ray_cast_group.translation = ray_cast_group.translation - potential_translation
	return on_surface
