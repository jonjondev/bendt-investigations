extends Spatial

func _process(_delta):
	var camera = get_viewport().get_camera()
	var look = camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
	look_at(translation + look, Vector3.UP)
	rotate_object_local(Vector3.BACK, camera.rotation.z)
