extends StaticBody2D

class_name Toilet

@export
var tag: String = "orange"

var _is_hovered := false


func check_is_hovered() -> bool:
	return _is_hovered


func _ready():
	mouse_entered.connect(_handle_mouse_enter)
	mouse_exited.connect(_handle_mouse_exit)
	

func _handle_mouse_enter():
	_is_hovered = true


func _handle_mouse_exit():
	_is_hovered = false
