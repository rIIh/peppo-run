extends Node

class_name GameMode

enum State {
	drawing,
	running,
	failed,
	success,
}

var smoke_fighting_prefab: PackedScene = preload("res://prefabs/fighting_particles.tscn")

var poops: Array[Poop] = []
var toilets: Array[Toilet] = []
var sitted_poops: Array[Poop] = []
var failed: bool = false

var _assignments: Dictionary = {}

var _state: State = State.drawing :
	set(value):
		if (_state != value):
			state_changed.emit(value)
		_state = value
var state: State :
	get: return _state


signal state_changed(state: State)

func _ready():
	for child in get_children():
		if child is Poop:
			poops.append(child)
			child.game_mode = self
		if child is Toilet:
			toilets.append(child)


func assign_poop_to_toilet(poop: Poop, toilet: Toilet) -> bool:
	if _state != State.drawing: return false

	if toilet in _assignments or poop.tag != toilet.tag:
		return false

	_assignments[toilet] = poop

	_update_state()

	return true


func reset_poop_assignment(poop: Poop):
	var toilet = _assignments.find_key(poop)
	if toilet:
		_assignments.erase(toilet)


func report_sitted(poop: Poop):
	if poop not in sitted_poops:
		sitted_poops.append(poop)

	_update_state()


func report_fighting(position: Vector2):
	failed = true
	_update_state()
	
	var smoke = smoke_fighting_prefab.instantiate()
	smoke.position = position
	add_child(smoke)

func _update_state():
	match(state):
		State.drawing:
			if _assignments.size() == toilets.size():
				_state = State.running

				for poop in poops:
					poop.start_movement()
		State.running:
			if failed:
				_state = State.failed
			elif sitted_poops.size() == toilets.size():
				_state = State.success

