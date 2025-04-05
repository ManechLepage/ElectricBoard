extends Node2D

@export var components: Array[Component]
@export var budget: int = 0
@onready var hotbar: Node2D = $CanvasLayer/hotbar
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hotbar.load_hotbar(components)

func get_components():
	return components

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(Game.money_spent) + " / " + str(budget)
