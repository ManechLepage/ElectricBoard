class_name GameManager
extends Node

var components: Array[Component]
var money_spent = 0
signal place_component_request(component: Component, position: Vector2i)
signal erase_component(position: Vector2i)
signal grid_changed
signal short_circuit

enum SelectionType {
	DEFAULT
}
var main = preload("res://Scenes/main.tscn")
var grid_manager: GridManager
var selection_type: SelectionType = SelectionType.DEFAULT

var current_selected_component: Component

func _ready() -> void:
	var main_inst = main.instantiate()
	components = main_inst.get_components()
	grid_manager = get_tree().get_first_node_in_group("Grid")

func _process(delta: float) -> void:
	if selection_type == SelectionType.DEFAULT:
		if grid_manager:
			grid_manager.draw_selection()

func get_component_by_name(name: StringName) -> Component:
	for component in components:
		if component.name == name:
			return component
	return null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		if current_selected_component:
			place_component_request.emit(current_selected_component, grid_manager.get_mouse_grid_position())

	if Input.is_action_just_pressed("RightClick"):
		erase_component.emit(grid_manager.get_mouse_grid_position())
	
func _on_grid_changed() -> void:
	money_spent = 0
	for component in grid_manager.components:
		money_spent += component.price
