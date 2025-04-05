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
			var paths: Array = conduct(_source)
			calculate_current(paths, source.volts, source.power/source.volts)
			if is_short_circuit(paths):
				Game.short_circuit.emit()
			for conductor: Conductor in Game.grid_manager.components:
				if conductor is Consumer:
					var consumer: Consumer = conductor
					print(consumer.name, ": ", consumer.is_activated)

func is_short_circuit(paths: Array) -> bool:
	for path in paths:
		for conductor: Conductor in path:
			if conductor is Consumer:
				return false
	return true

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

func calculate_current(valid_paths: Array, voltage: float, current: float) -> void:
	if valid_paths.size() == 1:
		calculate_single_path(valid_paths, voltage, current)
	elif valid_paths.size() > 1:
		calculate_multiple_paths(valid_paths, voltage, current)

func calculate_single_path(valid_paths: Array, voltage: float, current: float) -> void:
	set_current(current, valid_paths[0])
	var resistance: float = get_total_resistance(valid_paths[0])
	var consumers: Array[Consumer] = get_consumers(valid_paths[0])
	var total_volts = source.volts
	for consumer: Consumer in consumers:
		total_volts -= consumer.volts
	if total_volts > 0:
		for consumer: Consumer in consumers:
			consumer.is_activated = true
	else:
		for consumer: Consumer in consumers:
			consumer.is_activated = false

func calculate_multiple_paths(valid_paths: Array, voltage: float, current: float) -> void:
	var resistance: float = calculate_total_resistance(valid_paths)
	var common_path: Array[Conductor] = get_common_paths(valid_paths)
	
	var new_voltage = voltage
	for consumer: Consumer in get_consumers(common_path):
		new_voltage -= consumer.volts
	
	for path in paths:
		for conductor: Conductor in path:
			if conductor in common_path:
				path.erase(conductor)
	
	var path_groups = get_path_groups(paths)
	for path_group in path_groups:
		calculate_current(path_group, new_voltage, new_voltage/resistance)

func get_path_groups(paths_without_common: Array) -> Array:
	var path_groups: Array
	for path in paths:
		var is_not_sorted: bool = true
		for path_group in path_groups:
			if path in path_group:
				is_not_sorted = false
		if is_not_sorted:
			var common: Array = [path]
			for compared_path in paths:
				if get_common_paths([compared_path,path]).size() != 0:
					common.append(compared_path)
			path_groups.append(common)
	return path_groups

func calculate_total_resistance(paths: Array) -> float:
	var total_resistance: float
	if paths.size() == 1:
		for consumer: Consumer in get_consumers(paths[0]):
			total_resistance += consumer.resistance
		return total_resistance
	var common_path = get_common_paths(paths)
	total_resistance += calculate_total_resistance([common_path])
	
	for path in paths:
		for conductor: Conductor in path:
			if conductor in common_path:
				path.erase(conductor)
	
	var path_groups: Array = get_path_groups(paths)
	var resistance_in_path_groups: float
	for path_group in path_groups:
		resistance_in_path_groups += 1/calculate_total_resistance(path_group)
	
	total_resistance += 1/resistance_in_path_groups
	
	return total_resistance

func get_common_paths(paths: Array) -> Array[Conductor]:
	var path_lengths: Array[int]
	var common_path: Array[Conductor]
	for path in paths:
		for conductor in path:
			for pathos in paths:
				if conductor in paths:
					common_path.append(conductor)
	return common_path

func get_consumers(conductors: Array[Conductor]) -> Array[Consumer]:
	var consumers: Array[Consumer]
	for conductor in conductors:
		if conductor is Consumer:
			consumers.append(conductor as Consumer)
	return consumers

func set_current(current: float, conductors: Array[Conductor]) -> void:
	for component: Conductor in conductors:
		component.current = current

func get_total_resistance(conductors: Array[Conductor]) -> float:
	var total_resistance: float
	for component: Conductor in conductors:
		total_resistance += component.resistance
	return total_resistance
