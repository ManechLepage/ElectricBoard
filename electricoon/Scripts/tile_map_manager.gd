class_name GridManager
extends Node2D

@onready var base: TileMapLayer = $Base
@onready var components_grid: TileMapLayer = $Components
@onready var overlay: TileMapLayer = $Overlay
@onready var component_overlay: TileMapLayer = $ComponentOverlay

var components: Array[Component]

func get_mouse_grid_position() -> Vector2i:
	return overlay.local_to_map(get_global_mouse_position())

func reset_overlay() -> void:
	for tile in overlay.get_used_cells():
		overlay.erase_cell(tile)
	for tile in component_overlay.get_used_cells():
		component_overlay.erase_cell(tile)

func draw_selection() -> void:
	reset_overlay()
	
	var  tile_coords: Vector2i = get_mouse_grid_position()
	if tile_coords in base.get_used_cells():
		overlay.set_cell(get_mouse_grid_position(), 0, Vector2i(0, 1))
		if Game.current_selected_component:
			draw_overlay_component(Game.current_selected_component, get_mouse_grid_position())

func draw_component(component: Component, pos: Vector2i) -> void:
	components_grid.set_cell(pos, 0, component.sprite_atlas_coord)
	var added_component: Component = component.duplicate(true)
	added_component.position = pos
	components.append(added_component)


func draw_overlay_component(component: Component, pos: Vector2i) -> void:
	component_overlay.set_cell(pos, 0, component.sprite_atlas_coord)

func handle_component_request(component: Component, pos: Vector2i) -> void:
	pass
