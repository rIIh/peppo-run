@tool
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var eye_distance: float = 115 :
	set(value):
		eye_distance = value

		var circle_shape = $eye_detector/circle_collider.shape
		circle_shape.radius = value

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _target: Poop


func _ready():
	if Engine.is_editor_hint():
		return

	$eye_detector.body_entered.connect(_handle_eye_detector_body_entered)


func _handle_eye_detector_body_entered(body: Node2D):
	if body is Poop and not _target:
		if _check_obstacles(self.global_position, body.global_position):
			return

		_target = body


func _check_obstacles(a: Vector2, b: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(a, b, 1 << 3)
	var result := space_state.intersect_ray(query)

	return not result.is_empty()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	if _target and _target.state == Poop.State.sitting:
		_target = null

	var direction = (_target.position - position).normalized() if _target else Vector2.ZERO
	velocity = direction * SPEED

	move_and_slide()

