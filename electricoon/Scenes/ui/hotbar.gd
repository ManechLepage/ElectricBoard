extends Node2D
@onready var tab_container: TabContainer = $TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Wires_tab"):
		tab_container.current_tab = 0
		Game.current_selected_component = null
	elif Input.is_action_just_pressed("Source_tab"):
		tab_container.current_tab = 1
		Game.current_selected_component = null
	elif Input.is_action_just_pressed("Mesures_tab"):
		tab_container.current_tab = 2
		Game.current_selected_component = null
	elif Input.is_action_just_pressed("Products_tab"):
		tab_container.current_tab = 3
		Game.current_selected_component = null
