class_name Stopper
extends Conductor

var is_stopped: bool = true

func update_connections(new_connections: Array[bool]) -> Vector2i:
	var pos: = super(new_connections)
	if is_stopped:
		return pos
	return pos + Vector2i(0, 1)

func click():
	is_stopped != is_stopped
	Game.grid_changed.emit()
