@tool
extends Node2D

@export
var length: float = 968 / 4 :
	set(value):
		if (length == value): 
			return
			
		length = value
		_update_nodes()


func _ready():
	_update_nodes()


func _update_nodes():
	if is_inside_tree():
		$road.size.y = length * 4
		$road.position = Vector2($road.position.x, -length / 2)
