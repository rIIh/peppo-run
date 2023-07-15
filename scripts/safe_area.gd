@tool

extends MarginContainer

class_name SafeArea

@export
var debug_insets := EdgeInsets.new(0, 47, 0, 34) :
	set(value):
		debug_insets = value
		calculate()

@export
var minimum := EdgeInsets.zero :
	set(value):
		minimum = value
		calculate()

var view_rect: Rect2i
var _safe_area: Rect2i
var view_padding: EdgeInsets

var padding: EdgeInsets :
	get:
		return EdgeInsets.take_max(view_padding, minimum)



func _ready():
	debug_insets.changed.connect(calculate)
	minimum.changed.connect(calculate)
	resized.connect(calculate)
	calculate()


func _get_tool_buttons(): 
	return [
		{
			call=calculate,
			text="Recalculate",
		}
	]


# TODO: divide by pixel density in parent
# TODO: add MediaQuery Node with pixel density and insets
func calculate():
	if not get_viewport():
		return
		
	# TODO: use get_tree().scale ?
	var scale = ProjectSettings.get_setting("display/window/stretch/scale")
	var editor_resolution = Vector2i(ProjectSettings.get_setting(
		"display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"
	))

	var view_size = editor_resolution if Engine.is_editor_hint() else get_viewport().size

	view_rect = Rect2i(Vector2i(0, 0), view_size)
	_safe_area = DisplayServer.get_display_safe_area()
	view_padding = debug_insets if Engine.is_editor_hint() and debug_insets else EdgeInsets.from_rect_inside_rect(_safe_area, view_rect).only_positive()
	if not Engine.is_editor_hint():
		view_padding = EdgeInsets.divide(view_padding, scale)

	var padding = self.padding

	add_theme_constant_override("margin_left", padding.left)
	add_theme_constant_override("margin_top", padding.top)
	add_theme_constant_override("margin_right", padding.right)
	add_theme_constant_override("margin_bottom", padding.bottom)
	queue_sort()

