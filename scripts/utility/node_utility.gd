extends Object
class_name NodeUtilities


# Note: passing a value for the type parameter causes a crash
static func get_child_of_type(node: Node, child_type) -> Node:
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child, child_type):
			return child

	return null

# Note: passing a value for the type parameter causes a crash
static func find_of_type(nodes: Array[Node], child_type) -> Node:
	for node in nodes:
		if is_instance_of(node, child_type):
			return node

	return null

# Note: passing a value for the type parameter causes a crash
static func get_parent_of_type(node: Node, child_type) -> Node:
	if is_instance_of(node, child_type):
		return node
	elif node.get_parent():
		return get_parent_of_type(node.get_parent(), child_type) 
	else:
		return null
