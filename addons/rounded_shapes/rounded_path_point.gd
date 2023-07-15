@tool
class_name RoundedPathPoint extends Resource

@export
var value: Vector2

@export
var radius: float

func _init(value: Vector2 = Vector2.ZERO, radius: float = 0):
	self.value = value
	self.radius = radius
