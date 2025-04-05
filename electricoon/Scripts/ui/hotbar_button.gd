extends Button
@onready var cost_l: Label = $cost
@onready var hotkey_l: Label = $hotkey
@onready var comp_sprite: TextureRect = $sprite

var keys = [KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5]
@onready var button: Button = $"."
@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

var component: Component

func load_component(_component: Component) -> void:
	component = _component
	comp_sprite.texture = component.sprite
	cost_l.text = str(component.price)
	hotkey_l.text = str(component.hotkey)
	label.text = component.description

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	for key in keys:
		if Input.is_key_pressed(key):
			for comp in _get_component_with_hotkey(keys.find(key)):
				if button.get_parent().get_parent().visible == true and component == comp:
					Game.current_selected_component = comp
					
		
func _get_component_with_hotkey(wanted_hotkey):
	var list_components = []
	for i in range(4):
		for component in Game.components:
			if component.hotkey == wanted_hotkey:
				list_components.append(component)
	return(list_components)


func _on_pressed() -> void:
	Game.current_selected_component = component


func _on_button_pressed() -> void:
	if panel.visible:
		panel.visible = false
	else:
		panel.visible = true
