@tool
extends StaticBody2D

@export
var x_alignment: float = 0 :
	set(value):
		if (x_alignment == value): 
			return
			
		x_alignment = value
		_update_nodes()

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
		$wall_sprite.position = Vector2(-width / 2 + (width / 2 * x_alignment), 0)
		$collider.shape.size.x = width
		$collider.position = Vector2(width * x_alignment, 10) / 2
