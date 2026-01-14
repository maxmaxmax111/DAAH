extends Node3D

@export var admiral: Node
@export var total_supply_label: Label
@export var supply_remaining_label: Label
@export var total_supply: int = 30
var supply_remaining : int
@export var unit_widget_container: Control
@export var pawn_widget: DraftUnitWidget
@export var knight_widget: DraftUnitWidget
@export var bishop_widget: DraftUnitWidget
@export var rook_widget: DraftUnitWidget
@export var queen_widget: DraftUnitWidget
@export var go_button: Button
@export var queen_limit: int = 1
@export var rook_limit: int = 2

enum UnitType {PAWN, KNIGHT, BISHOP, ROOK, QUEEN}

func _ready():
	supply_remaining = total_supply
	total_supply_label.text = str(total_supply)
	supply_remaining_label.text = str(supply_remaining)
	admiral.set_portrait()
	go_button.button_up.connect(begin_battle)
	
	#pawn widget
	pawn_widget.add_button.button_up.connect(update_army.bind(-1, UnitType.PAWN, pawn_widget))
	pawn_widget.remove_button.button_up.connect(update_army.bind(1, UnitType.PAWN, pawn_widget))
	pawn_widget.unit_cost.text = str(UnitInfo.pawn_supply)
	pawn_widget.unit_size.text = str(UnitInfo.pawn_size)

	#knight widget
	knight_widget.add_button.button_up.connect(update_army.bind(-2, UnitType.KNIGHT, knight_widget))
	knight_widget.remove_button.button_up.connect(update_army.bind(2, UnitType.KNIGHT, knight_widget))
	knight_widget.unit_cost.text = str(UnitInfo.knight_supply)
	knight_widget.unit_size.text = str(UnitInfo.knight_size)
	
	#bishop widget
	bishop_widget.add_button.button_up.connect(update_army.bind(-3, UnitType.BISHOP, bishop_widget))
	bishop_widget.remove_button.button_up.connect(update_army.bind(3, UnitType.BISHOP, bishop_widget))
	bishop_widget.unit_cost.text = str(UnitInfo.bishop_supply)
	bishop_widget.unit_size.text = str(UnitInfo.bishop_size)

	#rook widget
	rook_widget.add_button.button_up.connect(update_army.bind(-5, UnitType.ROOK, rook_widget))
	rook_widget.remove_button.button_up.connect(update_army.bind(5, UnitType.ROOK, rook_widget))
	rook_widget.unit_cost.text = str(UnitInfo.rook_supply)
	rook_widget.unit_size.text = str(UnitInfo.rook_size)

	#queen widget
	queen_widget.add_button.button_up.connect(update_army.bind(-9, UnitType.QUEEN, queen_widget))
	queen_widget.remove_button.button_up.connect(update_army.bind(9, UnitType.QUEEN, queen_widget))
	queen_widget.unit_cost.text = str(UnitInfo.queen_supply)
	queen_widget.unit_size.text = str(UnitInfo.queen_size)

	match(PlayerArmy.army_type):
		PlayerArmy.ArmyType.DEMONS:
			#pawn widget
			pawn_widget.unit_name.text = UnitInfo.demon_pawn_name
			pawn_widget.unit_portrait.texture = UnitInfo.demon_pawn_portrait

			#knight widget
			knight_widget.visible = true
			knight_widget.unit_name.text = UnitInfo.demon_knight_name
			knight_widget.unit_portrait.texture = UnitInfo.demon_knight_portrait
			
			#bishop widget
			bishop_widget.visible = true
			bishop_widget.unit_name.text = UnitInfo.demon_bishop_name
			bishop_widget.unit_portrait.texture = UnitInfo.demon_bishop_portrait

			#rook widget
			rook_widget.visible = true
			rook_widget.unit_name.text = UnitInfo.demon_rook_name
			rook_widget.unit_portrait.texture = UnitInfo.demon_rook_portrait

			#queen widget
			queen_widget.visible = true
			queen_widget.unit_name.text = UnitInfo.demon_queen_name
			queen_widget.unit_portrait.texture = UnitInfo.demon_queen_portrait
	
		PlayerArmy.ArmyType.ANGELS:
			#pawn widget
			pawn_widget.unit_name.text = UnitInfo.angel_pawn_name
			pawn_widget.unit_portrait.texture = UnitInfo.angel_pawn_portrait

			#knight widget
			knight_widget.visible = true
			knight_widget.unit_name.text = UnitInfo.angel_knight_name
			knight_widget.unit_portrait.texture = UnitInfo.angel_knight_portrait
			
			#bishop widget
			bishop_widget.visible = true
			bishop_widget.unit_name.text = UnitInfo.angel_bishop_name
			bishop_widget.unit_portrait.texture = UnitInfo.angel_bishop_portrait

			#rook widget
			rook_widget.visible = true
			rook_widget.unit_name.text = UnitInfo.angel_rook_name
			rook_widget.unit_portrait.texture = UnitInfo.angel_rook_portrait

			#queen widget
			queen_widget.visible = true
			queen_widget.unit_name.text = UnitInfo.angel_queen_name
			queen_widget.unit_portrait.texture = UnitInfo.angel_queen_portrait
		
		PlayerArmy.ArmyType.ALIENS:
			#pawn widget
			pawn_widget.unit_name.text = UnitInfo.alien_pawn_name
			pawn_widget.unit_portrait.texture = UnitInfo.alien_pawn_portrait

			#knight widget
			knight_widget.visible = true
			knight_widget.unit_name.text = UnitInfo.alien_knight_name
			knight_widget.unit_portrait.texture = UnitInfo.alien_knight_portrait
			
			#bishop widget
			bishop_widget.visible = true
			bishop_widget.unit_name.text = UnitInfo.alien_bishop_name
			bishop_widget.unit_portrait.texture = UnitInfo.alien_bishop_portrait

			#rook widget
			rook_widget.visible = true
			rook_widget.unit_name.text = UnitInfo.alien_bishop_name
			rook_widget.unit_portrait.texture = UnitInfo.alien_bishop_portrait

			#queen widget
			queen_widget.visible = true
			queen_widget.unit_name.text = UnitInfo.alien_queen_name
			queen_widget.unit_portrait.texture = UnitInfo.alien_queen_portrait

		PlayerArmy.ArmyType.HUMANS:
			#pawn widget
			pawn_widget.unit_name.text = UnitInfo.human_pawn_name
			pawn_widget.unit_portrait.texture = UnitInfo.human_pawn_portrait

			#knight widget
			knight_widget.visible = true
			knight_widget.unit_name.text = UnitInfo.human_knight_name
			knight_widget.unit_portrait.texture = UnitInfo.human_knight_portrait
			
			#bishop widget
			bishop_widget.visible = true
			bishop_widget.unit_name.text = UnitInfo.human_bishop_name
			bishop_widget.unit_portrait.texture = UnitInfo.human_bishop_portrait

			#rook widget
			rook_widget.visible = true
			rook_widget.unit_name.text = UnitInfo.human_rook_name
			rook_widget.unit_portrait.texture = UnitInfo.human_rook_portrait

			#queen widget
			queen_widget.visible = true
			queen_widget.unit_name.text = UnitInfo.human_queen_name
			queen_widget.unit_portrait.texture = UnitInfo.human_queen_portrait
		_:
			print("army type not set")
	
	admiral.speak("Good day commander, let's choose our troops wisely!")

func update_army(change: int, unit_type: UnitType, _unit_widget: DraftUnitWidget):
	if(change > 0 && _unit_widget.unit_count.text == "0"):
		return
	elif(change < 0 && supply_remaining == 0 || change * -1 > supply_remaining):
		return
	

	if(unit_type == UnitType.PAWN):
		PlayerArmy.pawns += 1 if change < 0 else -1
		pawn_widget.unit_count.text = str(PlayerArmy.pawns)
	elif(unit_type == UnitType.KNIGHT):
		PlayerArmy.knights += 1 if change < 0 else -1
		knight_widget.unit_count.text = str(PlayerArmy.knights)
	elif(unit_type == UnitType.BISHOP):
		PlayerArmy.bishops += 1 if change < 0 else -1
		bishop_widget.unit_count.text = str(PlayerArmy.bishops)
	elif(unit_type == UnitType.ROOK):
		if(change<0 && PlayerArmy.rooks == 2):
			return
		PlayerArmy.rooks += 1 if change < 0 else -1
		rook_widget.unit_count.text = str(PlayerArmy.rooks)
	elif(unit_type == UnitType.QUEEN):
		if(change<0 && PlayerArmy.queens == 1):
			return
		PlayerArmy.queens += 1 if change < 0 else -1
		queen_widget.unit_count.text = str(PlayerArmy.queens)

	supply_remaining += change
	supply_remaining_label.text = str(supply_remaining)

	if(supply_remaining == 0):
		go_button.disabled = false
	else:
		go_button.disabled = true

func begin_battle():
	get_tree().change_scene_to_file("res://test123.tscn")
