extends Object
class_name NodeUtilities


# Note: passing a value for the type parameter causes a crash
static func get_child_of_type(node: Node, child_type) -> Node:
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child, child_type):
			return child
			
	return null
