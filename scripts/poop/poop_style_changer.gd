@tool
extends Node

class_name PoopStyleChanger

@export
var style: PoopStyle

@export
var poop: Poop

@export
var sprite: Sprite2D

@export
var line_renderer: Line2D


func _ready():
	_setup()
	_update_nodes()

	if not Engine.is_editor_hint():
		if poop:
			poop.state_changed.connect(_handle_state_change)


func _setup():
	if not poop:
		var parent = get_parent()
		if parent is Poop:
			poop = parent

	if not style or (poop and style != poop.style):
		style = poop.style if poop else preload("res://resources/poops/orange.tres")


func _update_nodes():
	if style:
		if sprite and sprite.texture != style.waiting:
			sprite.texture = style.waiting
		if line_renderer and line_renderer.default_color != style.line_color:
			line_renderer.default_color = style.line_color

func _process(delta):
	if Engine.is_editor_hint():
		_setup()
		_update_nodes()


func _handle_state_change(state: Poop.State):
	if sprite and style:
		match(state):
			Poop.State.waiting:
				sprite.texture = style.waiting
			Poop.State.walking:
				sprite.texture = style.walking
			Poop.State.sitting:
				await poop.sit_tween_completed
				if (poop.state == Poop.State.sitting):
					sprite.texture = style.sitting
