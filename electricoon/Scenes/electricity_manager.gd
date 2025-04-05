class_name ElectricityManager
extends Node

signal finished

var paths: Array = []
var current_path: Array[Conductor]
var visited_paths := {}
var source: Source = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Test3"):
		var _source: Source = Game.grid_manager.get_source()
		if _source:
			calculate_current(conduct(_source))

func conduct(_source: Source) -> Array:
	source = _source
	paths.clear()
	current_path.clear()
	visited_paths.clear()
	current_path.append(source)
	
	dfs(source)
	var valid_paths: Array
	for path in paths:
		if path.size() > 3 and path[1] == Game.grid_manager.get_component_from_position(source.get_positive_position()):
			valid_paths.append(path)
	return valid_paths

func dfs(current_conductor: Conductor) -> void:
	#if current_conductor != source:
	visited_paths[current_conductor] = true

	for neighbor: Conductor in current_conductor.connected_conductors:
		if neighbor == source:
			var path_copy = current_path.duplicate()
			path_copy.append(source)
			paths.append(path_copy)
		elif not visited_paths.has(neighbor):
			current_path.append(neighbor)
			dfs(neighbor)
			current_path.pop_back()

	if current_conductor != source:
		visited_paths.erase(current_conductor)

func calculate_current(valid_paths: Array) -> void:
	if valid_paths.size() == 1:
		set_current(source.power/source.volts, valid_paths[0])
		var resistance: float = get_total_resistance(valid_paths[0])
		var consumers: Array[Consumer]
		for conductor: Conductor in valid_paths[0]:
			if conductor is Consumer:
				var consumer = conductor as Consumer
				consumers.append(consumer)
		var total_volts = source.volts
		for consumer: Consumer in consumers:
			total_volts -= consumer.volts
		if total_volts > 0:
			for consumer: Consumer in consumers:
				consumer.is_activated = true
		else:
			for consumer: Consumer in consumers:
				consumer.is_activated = false

func set_current(current: float, conductors: Array[Conductor]) -> void:
	for component: Conductor in conductors:
		component.current = current

func get_total_resistance(conductors: Array[Conductor]) -> float:
	var total_resistance: float
	for component: Conductor in conductors:
		total_resistance += component.resistance
	return total_resistance
