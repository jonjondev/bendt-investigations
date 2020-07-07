extends Spatial

export (int) var faces = 0
export (float) var spacing = 0.05

var text_scene = preload("res://src/3DText.tscn")
var texts = []

func _ready():
	var rotation_angle: float = exterior_angles(faces)
	for i in range(faces):
		var new_text = text_scene.instance()
		new_text.text = "Line " + str(i)
		texts.append(new_text)
		new_text.rotation_degrees = Vector3(i * rotation_angle, 0, 0)
		new_text.translate(Vector3(0, 0, spacing * (faces/2)))
		add_child(new_text)

func _physics_process(delta):
	rotate_x(delta * 0.5)

func exterior_angles(n: float) -> float:
	return 360.0/n
