class_name ElectricityManager
extends Node

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Test3"):
		var source: Source = Game.grid_manager.get_source()
		if source:
			conduct(source)

func conduct(source: Source) -> void:
	var components: Array
	var next: Component = Game.grid_manager.get_component_from_position(source.get_positive_position())
	var list: Array[Array] = next.conduct_current([], source)
	print(list)
