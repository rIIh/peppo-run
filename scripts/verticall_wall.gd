@tool
extends Node2D


@export
var y_alignment: float = 0 :
	set(value):
		if (y_alignment == value): 
			return
			
		y_alignment = value
		_update_nodes()

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
		var alignment = -y_alignment
		
		$wall_sprite.position = Vector2($wall_sprite.position.x, height / 2 * alignment - height / 2)
		$wall_sprite.size.y = height * 4
		
		$collider.shape.size.y = height
		$collider.position = Vector2(0, height / 2 * alignment)
