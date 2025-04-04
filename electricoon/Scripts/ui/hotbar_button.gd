extends Button
@onready var cost_l: Label = $cost
@onready var hotkey_l: Label = $hotkey
@onready var comp_sprite: TextureRect = $sprite


var component: Component

func load_component(_component: Component) -> void:
	component = _component
	comp_sprite.texture = component.sprite
	cost_l.text = str(component.price)
	hotkey_l.text = str(component.hotkey)

func _ready() -> void:
	load_component(Game.get_component_by_name("Wire"))
