@tool
class_name LevelDetails extends Resource

@export
var title: String

@export
var scene: PackedScene :
	set(value):
		scene = value
		if not value:
			return
		
		var regex := RegEx.new()
		regex.compile("(\\d+).+$")
		var matches := regex.search(value.resource_path)
		var name = matches.get_string(1)

		if name and not title:
			title = "LVL " + name
