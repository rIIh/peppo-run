extends CharacterBody2D

class_name Poop

enum State {
	waiting,
	walking,
	sitting,
	fighting,
	exploded,
}

var game_mode: GameMode

@onready
var _trajectory_planner: DrawPath = $static/trajectory_planner
var trajectory_planner: DrawPath :
	get: return _trajectory_planner

@onready
var _self_fighter: Fighter = NodeUtilities.get_child_of_type(self, Fighter)

@export
var tag: String = "orange"

@export
var speed: float = 100

@export
var style: PoopStyle = preload("res://resources/poops/orange.tres")

var explode = preload("res://prefabs/explode_particles.tscn")

var _index = 0
var _points: Array[Vector2]

var _state: State = State.waiting :
	set(value):
		if _state != value:
			state_changed.emit(value)
		_state = value
var state: State :
	get: return _state


var _fighting_with: Poop

signal state_changed(state: State)
signal walking_tween_completed

func _ready():
	if _self_fighter:
		_self_fighter.will_enter_to_fight.connect(
			func():
				game_mode.report_fighting()
				_state = State.fighting
		)
		_self_fighter.entered_to_fight.connect(
			func():
				$poop_sprite.visible = false
				walking_tween_completed.emit()
		)


func _physics_process(delta):
	if _points and state == State.walking:
		if (_index < _points.size()):
			var target = _points[_index]
			var position = self.global_position
			while target.distance_to(position) < 4:
				_index += 1
				if (_index >= _points.size()): return

				target = _points[_index]

			var velocity = (target - position).normalized() * self.speed
			self.velocity = velocity

		self.move_and_slide()

		if get_slide_collision_count():
			_state = State.exploded
			game_mode.report_exploded()
			$poop_sprite.visible = false

			var explosion = explode.instantiate()
			explosion.global_position = self.global_position + Vector2.UP * 40
			get_tree().root.add_child(explosion)
			explosion.burst()

func _check_collisions() -> bool:
	if get_slide_collision_count():
		_state = State.exploded
		game_mode.report_exploded()
		$poop_sprite.visible = false

		var explosion = explode.instantiate()
		explosion.global_position = self.global_position + Vector2.UP * 40
		get_tree().root.add_child(explosion)
		explosion.burst()

		return true

	return false


func check_has_path() -> bool:
	return trajectory_planner.check_has_trajectory()


func start_movement():
	if state != State.waiting: return

	if check_has_path():
		_index = 0
		_points = trajectory_planner.get_points()
		_state = State.walking


var _sit_tween: Tween
func _sit_down(toilet: Node2D):
	if state == State.sitting: return
	if not toilet is Toilet: return

	_state = State.sitting
	_self_fighter.enabled = false

	if _sit_tween:
		_sit_tween.kill()

	_sit_tween = create_tween()
	_sit_tween.tween_method(func(v): self.translate(v - self.position), self.position, toilet.position, .25)
	_sit_tween.tween_callback(
		func():
			game_mode.report_sitted(self)
			walking_tween_completed.emit()
	)


func _check_obstacles(a: Vector2, b: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(a, b, 1 << 3)
	var result := space_state.intersect_ray(query)

	return not result.is_empty()


var _fight_tween: Tween
func collide(body: Node2D):
	if body is Toilet and trajectory_planner.target_toilet == body:
		if _check_obstacles(self.global_position, body.global_position):
			return

		_sit_down(body)
