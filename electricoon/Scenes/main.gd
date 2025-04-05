extends Node2D

@export var components: Array[Component]
@export var preset: Array[Component]
@export_multiline var description: String
@export var budget: int = 0
@onready var hotbar: Node2D = $CanvasLayer/hotbar
@onready var label: Label = $Label
@onready var panel: Panel = $Panel
@onready var blueprint: TextureRect = $TextureRect
@onready var button: Button = $Button



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_components():
	return components

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(Game.money_spent) + " / " + str(budget)


func _on_button_pressed() -> void:
	hotbar.visible = true
	hotbar.load_hotbar(components)
	blueprint.visible = false
	button.visible = false
