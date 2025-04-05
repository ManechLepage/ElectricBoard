extends Camera2D

var target_zoom: float = 3.0

const MIN_ZOOM: float = 1.0
const MAX_ZOOM: float = 9.0
const ZOOM_INCREMENT: float = 0.8

const ZOOM_RATE: float = 8.0

var shake_fade: float

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			position -= event.relative / zoom / 1.5
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()

func zoom_in():
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out():
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(not is_equal_approx(zoom.x, target_zoom))

func apply_shake(strength: float, _shake_fade: float) -> void:
	shake_fade = _shake_fade
	shake_strength = strength

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
