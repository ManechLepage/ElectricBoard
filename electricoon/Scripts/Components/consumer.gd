class_name Consumer
extends Conductor

@export var volts: float

var is_activated: bool

@export var can_break: bool = false
@export var broken_limit: int

func update_connections(new_connections: Array[bool]) -> Vector2i:
	var pos: Vector2i = super(new_connections)
	if is_activated:
		return pos + Vector2i(0, 1)
	return pos
