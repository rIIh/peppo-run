@tool
extends Node2D

@export
var length: float = 242:
	set(value):
		if (length == value): 
			return
			
		length = value
		_update_nodes()


@export
var simulation_length: float = 242 :
	set(value):
		if (simulation_length == value): 
			return
		
		simulation_length = value
		_update_nodes()

func _ready():
	_update_nodes()


func _update_nodes():
	if is_inside_tree():
		$road.size.y = length * 4
		$road.position = Vector2(-length / 2, $road.position.y)
