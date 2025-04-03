class_name GridManager
extends Node2D

@onready var base: TileMapLayer = $Base
@onready var components: TileMapLayer = $Components
@onready var overlay: TileMapLayer = $Overlay

func get_mouse_grid_position() -> Vector2i:
	return overlay.local_to_map(get_global_mouse_position())

func _process(delta: float) -> void:
	pass
