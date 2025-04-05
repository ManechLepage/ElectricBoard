class_name Conductor
extends Component

@export var connections: Array[bool] = [false, false, false, false] #Up-Left-Down-Right

@export var current: float

@export var connected_conductors: Array[Component]

func update_connections(new_connections: Array[bool]) -> Vector2i:
	connections = new_connections
	var offset: Vector2i = Vector2i.ZERO
	
	# STRAIGHTS
	# Diagonal North West
	if connections[0] and not connections[1] and connections[2] and not connections[3]:
		offset.x += 2
	# Diagonal North East
	elif not connections[0] and connections[1] and not connections[2] and connections[3]:
		offset.x += 1
	
	# T-SHAPED
	# Without North West
	elif connections[0] and connections[1] and not connections[2] and connections[3]:
		offset.x += 3
	# Without North East
	elif connections[0] and connections[1] and connections[2] and not connections[3]:
		offset.x += 4
	# Without Sout East
	elif not connections[0] and connections[1] and connections[2] and connections[3]:
		offset.x += 5
	# Without Sout West
	elif connections[0] and not connections[1] and connections[2] and connections[3]:
		offset.x += 6
	
	# CORNERS
	# East
	elif connections[0] and not connections[1] and not connections[2] and connections[3]:
		offset.x += 7
	# South
	elif connections[0] and connections[1] and not connections[2] and not connections[3]:
		offset.x += 8
	# West
	elif not connections[0] and connections[1] and connections[2] and not connections[3]:
		offset.x += 9
	# North
	elif not connections[0] and not connections[1] and connections[2] and connections[3]:
		offset.x += 10
	
	# ENDS
	# North East
	elif not connections[0] and not connections[1] and not connections[2] and connections[3]:
		offset.x += 11
	# South East
	elif connections[0] and not connections[1] and not connections[2] and not connections[3]:
		offset.x += 12
	# South West
	elif not connections[0] and connections[1] and not connections[2] and not connections[3]:
		offset.x += 13
	# North West
	elif not connections[0] and not connections[1] and connections[2] and not connections[3]:
		offset.x += 14
	
	# ALL
	elif connections[0] and connections[1] and connections[2] and connections[3]:
		offset.x += 15
	
	update_connected_components()
	
	return sprite_atlas_coord + offset

func update_connected_components() -> void:
	connected_conductors.clear()
	for tile in Game.grid_manager.components_grid.get_surrounding_cells(position):
		var component: Component = Game.grid_manager.get_component_from_position(tile)
		if component:
			connected_conductors.append(component)
