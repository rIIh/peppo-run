@tool
extends CanvasItem


var origin_node: Node2D

func _process(delta):
	if not is_inside_tree():
		origin_node = null
		return

	var owner_transform = _find_owner_transform(get_parent())
	var global_transform := owner_transform.inverse() * get_global_transform()
	(material as ShaderMaterial).set_shader_parameter("global_transform", global_transform)


func _find_owner_transform(node: Node) -> Transform2D:
	if origin_node:
		return origin_node.get_global_transform()
	
	if NodeUtilities.get_child_of_type(node, FadeOrigin) and node is Node2D:
		origin_node = node
		return node.get_global_transform()

	if not node or not node.get_parent():
		return Transform2D.IDENTITY
		
	return _find_owner_transform(node.get_parent())
