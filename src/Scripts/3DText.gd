tool
extends Spatial

export (Color) var base_colour: Color
export (String) var text: String setget set_text
export (bool) var is_billboard: bool

	$Viewport/Control/Label.modulate = base_colour
func _process(_delta):
	if is_billboard:
		var camera: Camera = get_viewport().get_camera()
		var look: Vector3 = camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
		look_at(translation + look, Vector3.UP)
		rotate_object_local(Vector3.BACK, camera.rotation.z)

func set_text(value):
	text = value
	if not is_inside_tree():
		yield(self, 'ready')
	$Viewport/Control/Label.text = text
