@tool

extends MarginContainer

class_name SafeArea

@export
var debug_insets := EdgeInsets.new(0, 47, 0, 34)

@export
var minimum := EdgeInsets.zero

@export
var view_rect: Rect2i

@export
var safe_area: Rect2i

@export
var view_padding: EdgeInsets

func _ready():
	resized.connect(calculate)
	calculate()


func calculate():
	var editor_resolution = Vector2i(ProjectSettings.get_setting(
		"display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"
	))

	var view_size = editor_resolution if Engine.is_editor_hint() else get_viewport().size
	
	view_rect = Rect2i(Vector2i(0, 0), view_size)
	safe_area = DisplayServer.get_display_safe_area()
	view_padding = debug_insets if Engine.is_editor_hint() and debug_insets else EdgeInsets.from_rect_inside_rect(safe_area, view_rect).only_positive()
	
	add_theme_constant_override("margin_left", max(view_padding.left, minimum.left))
	add_theme_constant_override("margin_top", max(view_padding.top, minimum.top))
	add_theme_constant_override("margin_right", max(view_padding.right, minimum.right))
	add_theme_constant_override("margin_bottom", max(view_padding.bottom, minimum.bottom))

