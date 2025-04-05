extends Node2D
@onready var tab_container: TabContainer = $TabContainer

var component: Component
var hotbar_button = preload("res://Scenes/ui/hotbar_button.tscn")
@onready var containers = [$"TabContainer/Q Wires/HBoxContainer", $"TabContainer/W Source/HBoxContainer", $"TabContainer/E Mesures/HBoxContainer", $"TabContainer/R Products/HBoxContainer"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_hotbar()

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

func load_hotbar():
	for component in Game.components:
		var tab = component.tab_num
		var hot_but = hotbar_button.instantiate()
		containers[tab].add_child(hot_but)
		hot_but.load_component(component)
