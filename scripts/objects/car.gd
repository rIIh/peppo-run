class_name Car extends StaticBody2D

@export
var speed := 300.

signal position_changed(position: Vector2)

func _physics_process(delta):
	translate(Vector2.RIGHT * delta * speed)
	position_changed.emit(position)
