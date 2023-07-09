extends Control

# TODO: add border gizmo
class_name KeepRectInCamera

var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	camera.position = get_rect().get_center()
	var scale_x = get_viewport_rect().size.x / get_rect().size.x
	var scale_y = get_viewport_rect().size.y / get_rect().size.y
	
	print(get_viewport_rect(), ', ', get_rect(), ' -> ', scale_x, ', ', scale_y)
	
	var min_scale = min(scale_x, scale_y)
	camera.zoom = Vector2(min_scale, min_scale) if min_scale < 1 else Vector2.ONE
	print(camera.zoom)
