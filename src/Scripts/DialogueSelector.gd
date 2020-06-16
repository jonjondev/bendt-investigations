extends Spatial

func _input(event):
	if event.is_action("ui_select"):
		rotate_x(90)
