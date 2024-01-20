extends CanvasItem

signal pressed

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			pressed.emit()
