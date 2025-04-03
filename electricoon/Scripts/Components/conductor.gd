class_name Conductor
extends Component

@export var connections: Array[bool] = [false, false, false, false] #Up-Left-Down-Right

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
	
	return sprite_atlas_coord + offset
