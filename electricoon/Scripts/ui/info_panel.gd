extends Control

@onready var name_label: Label = $Panel/Name
@onready var description: Label = $Panel/ColorRect/Description
@onready var texture_rect: TextureRect = $Panel/TextureRect


func load_component(component: Component) -> void:
	name_label.text = component.name
	texture_rect.texture = component.sprite
	
	if component is Conductor:
		var conductor: Conductor = component as Conductor
		description.text = "Resistance: " + str(conductor.resistance) + "Ω\n"
	if component is Consumer:
		var consumer: Consumer = component as Consumer
		description.text = "Voltage: " + str(consumer.volts) + "v\n" 
		
