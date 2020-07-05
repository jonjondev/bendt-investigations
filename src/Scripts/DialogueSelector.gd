extends Spatial

export (int) var lines = 0

var text_scene = preload("res://src/3DText.tscn")
var texts = []

func _ready():
	for i in range(lines):
		var new_text = text_scene.instance()
		new_text.text = "Line " + i as String
		texts.append(new_text)
		add_child(new_text)
		new_text.rotate_x(i * interior_angles(lines))

func _input(event):
	if event.is_action("ui_select"):
		rotate_x(interior_angles(lines))

func interior_angles(n: int) -> int:
	return (n-2)*180/n
