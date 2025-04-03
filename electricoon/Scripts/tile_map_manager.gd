class_name GridManager
extends Node2D

@onready var base: TileMapLayer = $Base
@onready var components: TileMapLayer = $Components
@onready var overlay: TileMapLayer = $Overlay

func get_mouse_grid_position() -> Vector2i:
	return overlay.local_to_map(get_global_mouse_position())

func _process(delta: float) -> void:
	pass

func reset_overlay() -> void:
	for tile in overlay.get_used_cells():
		overlay.erase_cell(tile)

func draw_selection() -> void:
	reset_overlay()
	overlay.set_cell(get_mouse_grid_position(), 0, Vector2i(0, 1))
