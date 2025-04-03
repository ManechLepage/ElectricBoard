class_name GameManager
extends Node

@export var components: Array[Component]

enum SelectionType {
	DEFAULT
}

var grid_manager: GridManager
var selection_type: SelectionType = SelectionType.DEFAULT

var current_selected_component: Component

func _ready() -> void:
	grid_manager = get_tree().get_first_node_in_group("Grid")

func _process(delta: float) -> void:
	if selection_type == SelectionType.DEFAULT:
		grid_manager.draw_selection()

func get_component_by_name(name: StringName) -> Component:
	for component in components:
		if component.name == name:
			return component
	return null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Test1"):
		current_selected_component = get_component_by_name("Wire")
