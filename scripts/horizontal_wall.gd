@tool
extends StaticBody2D

@export
var width: int = 32 :
	set(value):
		if (width == value): 
			return
			
		width = value
		_update_nodes()


func _ready():
	_update_nodes()


func _update_nodes():
	if is_inside_tree():
		$wall_sprite.size.x = width * 4
		$collider.shape.size.x = width
		$collider.position = Vector2(width, 10) / 2
