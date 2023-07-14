extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _target: Poop


func _ready():
	$eye_detector.body_entered.connect(_handle_eye_detector_body_entered)


func _handle_eye_detector_body_entered(body: Node2D):
	if body is Poop and not _target:
		_target = body


func _physics_process(delta):
	var direction = (_target.position - position).normalized() if _target else Vector2.ZERO
	velocity = direction * SPEED
	
	move_and_slide()
	
