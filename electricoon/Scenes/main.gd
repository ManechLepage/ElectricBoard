extends Node2D

@export var components: Array[Component]
@export var preset: Array[Component]
@export_multiline var description: String
@export var budget: int = 0
@onready var hotbar: Node2D = $CanvasLayer/hotbar
@onready var label: Label = %Label
@onready var panel: Panel = $Panel

@onready var button: Button = %Button
@onready var blueprint: Control = %Start
@onready var short_sprite: Sprite2D = $Sprite2D
@onready var color_rect: ColorRect = %ColorRect



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("load_level")

func load_level() -> void:
	short_sprite.modulate.a = 0.0
	color_rect.modulate.a = 0.0
	Game.short_circuit.connect(short_circuit)

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

func short_circuit():
	short_sprite.modulate.a = 0.0
	color_rect.modulate.a = 0.0
	var tween = create_tween()
	var _tween = create_tween()
	tween.tween_property(short_sprite, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(color_rect, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	var tween2 = create_tween()
	var _tween2 = create_tween()
	tween2.tween_property(short_sprite, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN_OUT)
	_tween2.tween_property(color_rect, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN_OUT)
	await tween2.finished
