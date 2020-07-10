extends Spatial

export (Array) var lines = []
export (float) var spacing = 0.05
export (float) var scroll_speed = 1.0

var text_scene: PackedScene = preload("res://src/3DText.tscn")
var texts: Array = []
var selected_item = 0
var rotate_to = null
var rotation_amount = 0
var curve = Curve.new()

onready var rotation_angle: float = exterior_angles(lines.size())

func _ready():
	for i in range(lines.size()):
		var new_text = text_scene.instance()
		new_text.text = lines[i]
		texts.append(new_text)
		new_text.rotation_degrees = Vector3(i * rotation_angle, 0, 0)
		new_text.translate(Vector3(0, 0, spacing * (lines.size()/2)))
		add_child(new_text)
	curve.add_point(Vector2(0.0, 0.0))
	curve.add_point(Vector2(0.6, 0.8))
	curve.add_point(Vector2(0.5, 0.2))
	curve.add_point(Vector2(1.0, 1.0))

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		move_selection(1)
	if Input.is_action_just_pressed("ui_down"):
		move_selection(-1)

func move_selection(direction: int):
	selected_item = (selected_item + direction) % lines.size()
	rotate_to = rotation_angle * selected_item
	rotation_amount = 0

func _physics_process(delta):
	if rotate_to != null:
		if rotation_amount < 1.0:
			var new_rotation = rotation_degrees.x + (rotate_to - rotation_degrees.x) * curve.interpolate(rotation_amount)
			rotation_degrees.x = new_rotation
			rotation_amount += delta * scroll_speed
		else:
			rotation_degrees.x = rotate_to
			rotate_to = null

func exterior_angles(n: float) -> float:
	return 360.0/n
