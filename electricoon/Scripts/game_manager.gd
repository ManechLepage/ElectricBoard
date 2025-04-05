class_name GameManager
extends Node
@onready var control: Button = $CanvasLayer/Control
var components: Array[Component]
var money_spent = 0

signal short_circuit
signal place_component_request(component: Component, position: Vector2i)
signal erase_component(position: Vector2i)
signal grid_changed
signal handle_hover
signal diddy 
enum SelectionType {
	DEFAULT
}
@export var level_select: PackedScene
var main = preload("res://Scenes/main.tscn")
var grid_manager: GridManager
var selection_type: SelectionType = SelectionType.DEFAULT

var current_selected_component: Component

var is_grille: bool = false

func _ready() -> void:
	var main_inst = main.instantiate()
	components = main_inst.get_components()

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
	if grid_manager:
		handle_hover.emit()
		if Input.is_action_just_pressed("LeftClick"):
			if current_selected_component:
				place_component_request.emit(current_selected_component, grid_manager.get_mouse_grid_position())
			else:
				var component: Component = grid_manager.get_component_from_position(grid_manager.get_mouse_grid_position())
				if component:
					if component is Stopper:
						component.click()
				
		if Input.is_action_just_pressed("RightClick"):
			erase_component.emit(grid_manager.get_mouse_grid_position())
		if Input.is_action_just_pressed("Escape"):
			current_selected_component = null

func win_bulbs():
	var winning_quantity: int = grid_manager.get_parent().bulbs
	for component: Component in grid_manager.components:
		if component is Consumer:
			if component.is_activated:
				winning_quantity -= 1
	if winning_quantity < 1:
		return true
	return false

func _on_grid_changed() -> void:
	if is_grille:
		money_spent = 0
		for component in grid_manager.components:
			money_spent += component.price
		
		if money_spent < grid_manager.get_parent().budget:
			if win_bulbs():
				if grid_manager.get_parent().short_sprite.modulate.a == 0.0:
					grid_manager.get_parent().control.disabled = false
		grid_manager.footjob()

func finish() -> void:
	get_tree().change_scene_to_packed(level_select)
