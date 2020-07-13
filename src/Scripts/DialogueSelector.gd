extends Spatial

const sides = 8
const lines = 3

export (String) var line_1
export (String) var line_2
export (String) var line_3
export (float) var spacing = 0.05
export (float) var scroll_speed = 1.0
export (Curve) var scroll_curve

var text_scene: PackedScene = preload("res://src/3DText.tscn")
var text_positions: Array = []
var selected_item: int = 0
var rotation_amount: float = 0
var rotate_to = null

onready var texts: Array = [line_1, line_2, line_3]
onready var rotation_angle: float = exterior_angles(sides)
onready var player: Node = $"../../Player"

func _ready():
	for i in range(lines):
		var new_text = text_scene.instance()
		new_text.text = texts[i]
		new_text.rotation_degrees = Vector3(i * rotation_angle, 0, 0)
		text_positions.append(i * rotation_angle)
		new_text.translate(Vector3(0, 0, spacing * (sides/2.0)))
		add_child(new_text)
	move_selection(1)
	rotation_degrees.x = rotate_to
	rotate_to = null

func _input(_event):
	if player.in_action:
		if Input.is_action_just_pressed("ui_up"):
			move_selection(1)
		if Input.is_action_just_pressed("ui_down"):
			move_selection(-1)

func move_selection(direction: int):
	selected_item = (selected_item + direction) % lines
	if selected_item < 0:
		selected_item = 3 + selected_item
	rotate_to = texts.values()[selected_item]
	rotation_amount = 0

func _physics_process(delta):
	if rotate_to != null:
		if rotation_amount >= 1.0:
			rotation_degrees.x = rotate_to
			rotate_to = null
		else:
			var new_rotation = rotation_degrees.x + (rotate_to - rotation_degrees.x) * scroll_curve.interpolate(rotation_amount)
			rotation_degrees.x = new_rotation
			rotation_amount += delta * scroll_speed

func exterior_angles(n: float) -> float:
	return 360.0/n
