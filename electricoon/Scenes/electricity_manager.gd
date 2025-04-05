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
			conduct(_source)

func conduct(_source: Source) -> Array:
	source = _source
	paths.clear()
	current_path.clear()
	visited_paths.clear()
	current_path.append(source)
	
	dfs(source)
	for path in paths:
		if path.size() > 3 and path[1] == Game.grid_manager.get_component_from_position(source.get_positive_position()):
			print(path.size())
	return paths

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
