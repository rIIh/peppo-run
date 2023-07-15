@tool
extends Node2D


# TODO: copy alignment logic from horizontal wall
@export
var height: int = 32 :
	set(value):
		if (height == value): 
			return
			
		height = value
		_update_nodes()

func _ready():
	_update_nodes()


func _update_nodes():
	if is_inside_tree():
		$wall_sprite.size.y = height * 4
		$collider.shape.size.y = height
		$collider.position = Vector2(0, height) / 2
