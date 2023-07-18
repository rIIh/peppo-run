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

@export
var animation_player: AnimationPlayer

@onready
var _last_position := poop.position
var _is_walking: bool = false

@onready
var _state: Poop.State = poop.state if not Engine.is_editor_hint() else -1


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
		if sprite and sprite.texture != style.texture:
			sprite.texture = style.texture
		if line_renderer and line_renderer.default_color != style.line_color:
			line_renderer.default_color = style.line_color


func _process(delta):
	if not Engine.is_editor_hint():
		if _is_walking:
			var delta_x = (poop.position - _last_position).x
			var to_right = delta_x > 0
			if abs(delta_x) > 2.5 * delta:
				_last_position = poop.position
				sprite.flip_h = not to_right

		elif sprite.scale.x < 0:
			sprite.flip_h = false
			sprite.scale.x = -sprite.scale.x

	if Engine.is_editor_hint():
		_setup()
		_update_nodes()


func _play(animation: StringName):
	if animation_player.current_animation != animation:
		animation_player.play(animation)

func _handle_state_change(state: Poop.State):
	if sprite and style:
		match(state):
			Poop.State.waiting:
				_play("waiting")

			Poop.State.walking:
				_is_walking = true
				
				_play("walking")

			Poop.State.sitting:
				await poop.walking_tween_completed

				_is_walking = false
				if poop.state == Poop.State.sitting:
					_play("sitting")

			Poop.State.fighting:
				await poop.walking_tween_completed

				_is_walking = false

			Poop.State.exploded:
				_is_walking = false

	_state = state

