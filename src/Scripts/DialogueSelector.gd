extends Spatial

export (Array) var lines = []
export (float) var spacing = 0.05
export (float) var scroll_speed = 0.5

var text_scene = preload("res://src/3DText.tscn")
var texts = []

func _ready():
	var rotation_angle: float = exterior_angles(lines.size())
	for i in range(lines.size()):
		var new_text = text_scene.instance()
		new_text.text = lines[i]
		texts.append(new_text)
		new_text.rotation_degrees = Vector3(i * rotation_angle, 0, 0)
		new_text.translate(Vector3(0, 0, spacing * (lines.size()/2)))
		add_child(new_text)

func _physics_process(delta):
	rotate_x(delta * -scroll_speed)

func exterior_angles(n: float) -> float:
	return 360.0/n
