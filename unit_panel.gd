extends PanelContainer

@export var unit_portrait: TextureRect
@export var unit_name: Label
@export var supply_cost: Label
@export var unit_size: Label

func select():
	self_modulate = Color.GREEN

func deselect():
	self_modulate = Color.WHITE