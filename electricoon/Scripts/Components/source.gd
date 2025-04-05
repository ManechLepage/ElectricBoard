class_name Source
extends Conductor

@export var volts: float
@export var power: float

func get_positive_position() -> Vector2i:
	if position.y % 2 == 0:
		return position + Vector2i(-1, 1)
	else:
		return position + Vector2i(0, 1)
