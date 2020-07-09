extends Spatial

export (Array) var lines = []
export (float) var spacing = 0.05
export (float) var scroll_speed = 0.1

var text_scene: PackedScene = preload("res://src/3DText.tscn")
var texts: Array = []
var rotate_to = 0

onready var rotation_angle: float = exterior_angles(lines.size())

func _ready():
	for i in range(lines.size()):
		var new_text = text_scene.instance()
		new_text.text = lines[i]
		texts.append(new_text)
		new_text.rotation_degrees = Vector3(i * rotation_angle, 0, 0)
		new_text.translate(Vector3(0, 0, spacing * (lines.size()/2)))
		add_child(new_text)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if not rotate_to:
			rotate_to = rotation_degrees.x + rotation_angle

func _physics_process(delta):
	if rotate_to != 0:
		if abs(rotation_degrees.x - rotate_to) > 1.0:
			var new_rotation = rotation_degrees.x + (rotate_to - rotation_degrees.x) * delta
			rotation_degrees.x = new_rotation + 1.0
		else:
			rotation_degrees.x = rotate_to
			rotate_to = 0

func exterior_angles(n: float) -> float:
	return 360.0/n
