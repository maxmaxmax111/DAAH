extends Node3D

@export var admiral: Node
@export var total_supply_label: Label
@export var supply_remaining_label: Label
@export var total_supply: int = 30
@export var supply_remaining: int = 30
@export var unit_widget_container: Control
@export var unit_widget: Control

enum ArmyType {DEMONS, ANGELS, ALIENS, HUMANS}
var army_type: ArmyType = ArmyType.DEMONS

func _ready():
	total_supply_label.text = str(total_supply)
	supply_remaining_label.text = str(supply_remaining)
	admiral.speak("Good day commander, let's choose our troops wisely!")
	match(army_type):
		ArmyType.DEMONS:
			pass

func update_supply(change: int):
	supply_remaining += change
	supply_remaining_label.text = str(supply_remaining)
