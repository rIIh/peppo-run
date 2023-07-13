@tool
extends CanvasLayer


@export
var offset_node: Control

@export
var tile_offset: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if offset_node:
		tile_offset = -offset_node.global_position
	$background/checker_pattern.material.set_shader_parameter("tile_offset", tile_offset)
	$background/checker_pattern.material.set_shader_parameter("custom_color", $background/checker_pattern.self_modulate)
		
