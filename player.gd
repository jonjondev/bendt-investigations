extends KinematicBody

var move_speed = 0.05
var gravity = Vector3(0, -10, 0)
var velocity = Vector3()

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
	translation = translation + move
	
	velocity += gravity * delta 
	velocity = move_and_slide(velocity)
