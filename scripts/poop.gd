@tool
extends CharacterBody2D

class_name Poop

enum State {
	waiting,
	walking,
	sitting,
}

var game_mode: GameMode

@onready
var _trajectory_planner: DrawPath = $static/trajectory_planner
var trajectory_planner: DrawPath :
	get: return _trajectory_planner

@export
var tag: String = "orange"

@export
var color: Color = Color("f4bd52")

@export
var speed: float = 100

@export
var sitting_sprite: Texture2D

@export
var waiting_sprite: Texture2D

var _index = 0
var _points: Array[Vector2]

var _state: State = State.waiting
var state: State :
	get: return _state


func _ready():
	if waiting_sprite and state == State.waiting:
		$poop_sprite.texture = waiting_sprite
	
	if color:
		$static/trajectory_renderer.default_color = color

func _process(delta):
	if Engine.is_editor_hint():
		if color:
			$static/trajectory_renderer.default_color = color
		if waiting_sprite:
			$poop_sprite.texture = waiting_sprite
	
	if Engine.is_editor_hint():
		return

	if _points and state == State.walking:
		if (_index >= _points.size()): return

		var target = _points[_index]
		var position = self.position
		while target.distance_to(position) < 1:
			_index += 1
			if (_index >= _points.size()): return

			target = _points[_index]

		var velocity = (target - self.position).normalized() * self.speed
		self.translate(velocity * delta)

func check_has_path() -> bool:
	return trajectory_planner.check_has_trajectory()

func start_movement():
	if state != State.waiting: return

	if check_has_path():
		_index = 0
		_points = trajectory_planner.get_points()
		_state = State.walking

var _sit_tween: Tween
func sit_down(toilet: Node2D):
	if state == State.sitting: return
	if not toilet is Toilet: return

	_state = State.sitting

	if _sit_tween:
		_sit_tween.kill()

	_sit_tween = create_tween()
	_sit_tween.tween_method(func(v): self.translate(v - self.position), self.position, toilet.position, .5)
	_sit_tween.tween_callback(
		func():
			$poop_sprite.texture = sitting_sprite
			game_mode.report_sitted(self)
	)

