class_name GameManager
extends Node

enum SelectionType {
	DEFAULT
}

var grid_manager: GridManager
var selection_type: SelectionType = SelectionType.DEFAULT

func _ready() -> void:
	grid_manager = get_tree().get_first_node_in_group("Grid")

func _process(delta: float) -> void:
	if selection_type == SelectionType.DEFAULT:
		grid_manager.draw_selection()
