@tool
class_name Worker extends CharacterBody2D


const SPEED = 300.0

var game_mode: GameMode
@onready var animation_tree = %AnimationTree

@export
var speed: float = 100

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
var _last_position: Vector2


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
	var velocity_normal = velocity.rotated(PI / 2).normalized()
	var offset_multiplier = 40
	
	var query_1 := PhysicsRayQueryParameters2D.create(a, b, 1 << 3)
	var result_1 := space_state.intersect_ray(query_1)
	var query_2 := PhysicsRayQueryParameters2D.create(a + velocity_normal * offset_multiplier, b, 1 << 3)
	var result_2 := space_state.intersect_ray(query_2)
	var query_3 := PhysicsRayQueryParameters2D.create(a - velocity_normal * offset_multiplier, b, 1 << 3)
	var result_3 := space_state.intersect_ray(query_3)

	return [result_1, result_2, result_3].reduce(func(a, r): return a || not r.is_empty(), false)
	
	
func _check_in_sight() -> bool:
	if not _target:
		return true
	
	return _target in _track_bodies
	
	
func _untrack_poops(list: Array[Poop]):
	for poop in list:
		_track_bodies.erase(poop)
	
func _check_tracked_bodies():
	var closest: Poop
	var closest_distance: float = 1e10
	var poops_to_erase: Array[Poop] = []
	
	for body in _track_bodies:
		if body.state != Poop.State.walking:
			poops_to_erase.append(body)
			continue
			
		if _check_obstacles(self.global_position, body.global_position):
			continue

		var distance = body.position.distance_to(self.global_position)
		closest = body if distance < closest_distance else closest

	_target = closest
	_last_position = _target.global_position if _target else Vector2.ZERO
	
	_untrack_poops(poops_to_erase)


func _physics_process(delta):
	if Engine.is_editor_hint():
		return
		
	if game_mode.state != GameMode.State.running:
		_change_state('is_waiting')
		velocity = Vector2.ZERO
		return
		
	if _target and not _check_obstacles(self.global_position, _target.global_position):
		if _check_in_sight():
			_last_position = _target.global_position
		else:
			_target = null

	if _target and _target.state == Poop.State.sitting:
		_untrack_poops([_target])
		_target = null
		
	if not _target:
		_check_tracked_bodies()

	if not _target:
		_change_state('is_waiting')

	var target_position = _last_position
	var direction = (target_position - position).normalized() if _target else Vector2.ZERO
	velocity = direction * SPEED * (speed / 100)
	
	if self.get_slide_collision_count():
		var collision = self.get_slide_collision(0)
		var angle = (-collision.get_normal()).angle_to(velocity) * 2 * PI
		velocity -= velocity.rotated(PI / 8 * (1 if angle > 0 else -1)).normalized() * 100

	elif velocity.x < 0:
		_change_state('is_walking_left')
	elif _target != null:
		_change_state('is_walking_right')

	move_and_slide()
	queue_redraw()


func _change_state(state: String):
	animation_tree['parameters/conditions/is_waiting'] = false
	animation_tree['parameters/conditions/is_walking_left'] = false
	animation_tree['parameters/conditions/is_walking_right'] = false
	
	animation_tree['parameters/conditions/%s' % state] = true

func _draw():
	return
	if _target:
		var has_obstacles = _check_obstacles(self.global_position, _target.global_position)
		draw_line(Vector2.ZERO, _target.global_position - self.global_position, Color.RED if has_obstacles else Color.GREEN, 4)
		draw_line(Vector2.ZERO, _last_position - self.global_position, Color.YELLOW, 4)
		
	if self.get_slide_collision_count():
		var collision = self.get_slide_collision(0)
		draw_line(Vector2.ZERO + Vector2(-100, 0), collision.get_normal() + Vector2(-100, 0), Color.BLUE)		
