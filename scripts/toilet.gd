@tool
extends StaticBody2D

class_name Toilet

@export
var tag: String = "orange"

@export
var poop_style: PoopStyle = preload("res://resources/poops/orange.tres")

var _is_hovered := false


func check_is_hovered() -> bool:
	return _is_hovered


func _ready():
	_setup()
	_update_nodes()

	if not Engine.is_editor_hint():
		mouse_entered.connect(_handle_mouse_enter)
		mouse_exited.connect(_handle_mouse_exit)


func _process(delta):
	if Engine.is_editor_hint():
		_update_nodes()


func _setup():
	if not poop_style:
		poop_style = preload("res://resources/poops/orange.tres")


func _update_nodes():
	if poop_style:
		if not $toilet_tag.visible:
			$toilet_tag.visible = true
		if $toilet_tag.self_modulate != poop_style.line_color:
			$toilet_tag.self_modulate = poop_style.line_color
	else:
		if $toilet_tag.visible:
			$toilet_tag.visible = false


func _handle_mouse_enter():
	_is_hovered = true


func _handle_mouse_exit():
	_is_hovered = false
