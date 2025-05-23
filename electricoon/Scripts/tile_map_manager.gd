class_name GridManager
extends Node2D
@onready var foot: Label = %foot
@onready var base: TileMapLayer = $Base
@onready var components_grid: TileMapLayer = $Components
@onready var overlay: TileMapLayer = $Overlay
@onready var component_overlay: TileMapLayer = $ComponentOverlay
@onready var carbon_footprint: TextureRect = $"../CanvasLayer/CarbonFootprint"

@onready var info_panel: Control = %InfoPanel

var components: Array[Component]

func _ready() -> void:
	Game.place_component_request.connect(handle_component_request)
	Game.grid_changed.connect(update_component_grid)
	Game.erase_component.connect(erase_component)
	Game.handle_hover.connect(handle_hover)
	Game.grid_manager = self
	Game.is_grille = true

func get_mouse_grid_position() -> Vector2i:
	return overlay.local_to_map(get_global_mouse_position())

func reset_overlay() -> void:
	for tile in overlay.get_used_cells():
		overlay.erase_cell(tile)
	for tile in component_overlay.get_used_cells():
		component_overlay.erase_cell(tile)
func _process(delta: float) -> void:
	var component: Component = get_component_from_position(get_mouse_grid_position())
	highlight(component)
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
	Game.grid_changed.emit()

func erase_component(pos: Vector2i) -> void:
	components.erase(get_component_from_position(pos))
	components_grid.erase_cell(pos)
	Game.grid_changed.emit()

func draw_overlay_component(component: Component, pos: Vector2i) -> void:
	component_overlay.set_cell(pos, 0, component.sprite_atlas_coord)

func handle_component_request(component: Component, pos: Vector2i) -> void:
	if is_open(pos):
		draw_component(component, pos)

func is_open(pos: Vector2i) -> bool:
	return pos in base.get_used_cells() and pos not in components_grid.get_used_cells()

func get_component_from_position(pos: Vector2i) -> Component:
	for component in components:
		if component.position == pos:
			return component
	return null

func update_component_grid() -> void:
	update_connections()

func update_connections() -> void:
	for component in components:
		if component is Conductor:
			var conductor = component as Conductor
			var new_atlas_coords: Vector2i = conductor.update_connections(get_connections(conductor.position))
			components_grid.set_cell(conductor.position, 0, new_atlas_coords)

func get_connections(pos: Vector2i) -> Array[bool]:
	var tiles: Array[Vector2i] = components_grid.get_surrounding_cells(pos)
	var connections: Array[bool]
	for tile in tiles:
		var surrounding_component = get_component_from_position(tile)
		if surrounding_component:
			if surrounding_component is Conductor:
				connections.append(true)
			else:
				connections.append(false)
		else:
			connections.append(false)
	return connections

func get_source() -> Source:
	for component in components:
		if component is Source:
			return component
	return null

func handle_hover() -> void:
	var component: Component = get_component_from_position(get_mouse_grid_position())
	if component:
		info_panel.visible = true
		info_panel.load_component(component)
		highlight(component)
	else:
		info_panel.visible = false

func highlight(component: Conductor) -> void:
	for _component: Conductor in components:
		if component:
			if component is Stopper:
				return
			if component.name == "Bulb":
				return
		if _component != component:
			_component.is_hovered = false
		else:
			_component.is_hovered = true
	Game.grid_changed.emit()

func footjob():
	if Game.is_grille and foot:
		var somme = 0
		for conductor: Conductor in Game.grid_manager.components:
			somme += conductor.resistance/100
		foot.text = str(somme) + "kg"
		carbon_footprint.scale = Vector2(1.281 + somme*4,1.281 +somme*4)
