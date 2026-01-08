extends Node3D

@export var admiral: Node
@export var total_supply_label: Label
@export var supply_remaining_label: Label
@export var total_supply: int = 30
@export var supply_remaining: int = 30
@export var unit_widget_container: Control
@export var unit_widget: DraftUnitWidget
@export var go_button: Button

enum ArmyType {DEMONS, ANGELS, ALIENS, HUMANS}
var army_type: ArmyType = ArmyType.DEMONS

enum UnitType {PAWN, KNIGHT, BISHOP, ROOK, QUEEN}

func _ready():
	total_supply_label.text = str(total_supply)
	supply_remaining_label.text = str(supply_remaining)
	admiral.speak("Good day commander, let's choose our troops wisely!")
	match(army_type):
		ArmyType.DEMONS:
			#pawn widget
			unit_widget.add_button.button_up.connect(update_army.bind(1, UnitType.PAWN, unit_widget))
			unit_widget.remove_button.button_up.connect(update_army.bind(-1, UnitType.PAWN, unit_widget))
			unit_widget.unit_name.text = UnitInfo.demon_pawn_name
			unit_widget.unit_cost.text = str(UnitInfo.demon_pawn_supply)
			unit_widget.unit_size.text = str(UnitInfo.demon_pawn_size)
			unit_widget.unit_portrait.texture = UnitInfo.demon_pawn_portrait

			#knight widget
			var knight_widget = unit_widget.duplicate()
			unit_widget_container.add_child(knight_widget)
			
			#bishop widget
			var bishop_widget = unit_widget.duplicate()
			unit_widget_container.add_child(bishop_widget)

			#rook widget
			var rook_widget = unit_widget.duplicate()
			unit_widget_container.add_child(rook_widget)

			#queen widget
			var queen_widget = unit_widget.duplicate()
			unit_widget_container.add_child(queen_widget)

func update_army(change: int, unit_type: UnitType, _unit_widget: DraftUnitWidget):
	if(change < 0 && _unit_widget.unit_count.text == "0"):
		return
	elif(change > 0 && supply_remaining == 0 || change > supply_remaining):
		return
	supply_remaining += change
	supply_remaining_label.text = str(supply_remaining)
	match(army_type):
		ArmyType.DEMONS:
			if(unit_type == UnitType.PAWN):
				PlayerArmy.demon_pawns += change
				unit_widget.unit_count.text = str(PlayerArmy.demon_pawns)
	if(supply_remaining == 0):
		go_button.disabled = false
	else:
		go_button.disabled = true