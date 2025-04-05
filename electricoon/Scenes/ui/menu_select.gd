extends Control

@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	go_down()
	
func go_down():
	var tween = create_tween()
	tween.tween_property(camera_2d, "position", Vector2(camera_2d.position.x, 1330.0), 1).set_trans(Tween.TRANS_QUAD)
