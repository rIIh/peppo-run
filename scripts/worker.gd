@tool
extends CharacterBody2D


const SPEED = 300.0


@export var eye_distance: float = 115 :
	set(value):
		eye_distance = value

		var circle_shape = $eye_detector/circle_collider.shape
		circle_shape.radius = value


@export var eye_sight: Shape2D :
	set(value):
		eye_sight = value
		if value:
			$eye_detector/circle_collider.shape = value
		else:
			$eye_detector/circle_collider.shape = CircleShape2D.new()
			eye_distance = eye_distance


var _target: Poop
var _track_bodies: Array[Poop] = []


func _ready():
	if Engine.is_editor_hint():
		return

	$eye_detector.body_entered.connect(_handle_eye_detector_body_entered)
	$eye_detector.body_exited.connect(_handle_eye_detector_body_exited)


func _handle_eye_detector_body_entered(body: Node2D):
	if body is Poop and not _target:
		_track_bodies.append(body)


func _handle_eye_detector_body_exited(body: Node2D):
	if body is Poop and not _target:
		_track_bodies.erase(body)


func _check_obstacles(a: Vector2, b: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(a, b, 1 << 3)
	var result := space_state.intersect_ray(query)

	return not result.is_empty()
	
	
func _check_tracked_bodies():
	var closest: Poop
	var closest_distance: float = 1e10
	for body in _track_bodies:
		if _check_obstacles(self.global_position, body.global_position):
			continue

		var distance = body.position.distance_to(self.global_position)
		closest = body if distance < closest_distance else closest

	_target = closest
	_track_bodies.erase(_target)


func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	if _target and _target.state == Poop.State.sitting:
		_target = null
		
	if not _target:
		_check_tracked_bodies()

	var direction = (_target.position - position).normalized() if _target else Vector2.ZERO
	velocity = direction * SPEED

	move_and_slide()

