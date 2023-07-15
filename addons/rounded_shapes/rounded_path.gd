@tool
class_name RoundedPath extends Resource

@export
var _points: Array[RoundedPathPoint] = []


func _init(points: Array[RoundedPathPoint] = []):
	_points = Array(points)


func build(corner_resolution: int = 10) -> Array[Vector2]:
	var list: Array[Vector2] = []
	for i in _points.size():
		var l1 := _points[i]
		var l2 := _points[(i + 1) % _points.size()]

		var d2: Vector2 = l2.value - l1.value
		var r1: Vector2 = l1.value + d2.normalized() * l1.radius
		var r2: Vector2 = l1.value  + d2.normalized() * (d2.length() - l2.radius)

		list.append(r1)
		list.append(r2)

		if l2.radius:
			var l3 := _points[(i + 2) % _points.size()]
			var d3: Vector2 = l3.value - l2.value
			var r3 := l2.value + d3.normalized() * l2.radius


			var arc: Array[Vector2] = []
			for t in corner_resolution + 1:
				if t == 0: continue
				const magic_number = 0.55228 # 0.44772 #
				var c1 = r2 + (l2.value - r2) * magic_number
				var c2 = r3 - (r3 - l2.value) * magic_number
				var x = bezier_interpolate(r2.x, c1.x, c2.x, r3.x, float(t) / corner_resolution)
				var y = bezier_interpolate(r2.y, c1.y, c2.y, r3.y, float(t) / corner_resolution)
				arc.append(Vector2(x, y))

			list.append_array(arc)

	return list


static func rectangle(center: Vector2, size: Vector2, radius: float) -> RoundedPath:
	return RoundedPath.new(
		[
			RoundedPathPoint.new(center + Vector2(-size.x, -size.y) / 2, radius),
			RoundedPathPoint.new(center + Vector2(size.x, -size.y) / 2, radius),
			RoundedPathPoint.new(center + Vector2(size.x, size.y) / 2, radius),
			RoundedPathPoint.new(center + Vector2(-size.x, size.y) / 2, radius),
		]
	)
