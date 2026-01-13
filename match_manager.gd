extends Node3D
class_name MatchManager

enum MatchState {DEPLOY, BATTLE, WAIT_FOR_OPPONENT, PAUSE}
var match_state: MatchState = MatchState.DEPLOY

@export var board: GameBoard

@export var player_unit_panel: Control
@export var unit_panel_container: Control

@export var admiral: AdmiralPanel

@export var confirm_button: Button

var unit_instance = preload("res://unit_2d.tscn")
var active_unit: ArmyUnit
var deploy_index: int = 0
func _ready():
	admiral.set_portrait()
	#admiral.speak("Deploy your units wisely, failure is not an option!")
	admiral.speak("A King may move a man, a father may claim a son, but remember that even when those who move you be Kings, or men of power, your soul is in your keeping alone.")
	GlobalSignals.tile_clicked.connect(handle_tile_input)
	confirm_button.button_up.connect(confirm_action)
	build_army()
	set_next_unit_for_deployment()
func create_unit_panel(unit_type: ArmyUnit.UnitType):
	var new_panel = player_unit_panel.duplicate()
	unit_panel_container.add_child(new_panel)
	new_panel.initialize(unit_type)
	new_panel.visible = true

func _process(_delta):
	pass

func build_army():
	for p in range(PlayerArmy.queens):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonQueen)
				add_army_unit(ArmyUnit.UnitType.DemonQueen)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelQueen)
				add_army_unit(ArmyUnit.UnitType.AngelQueen)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienQueen)
				add_army_unit(ArmyUnit.UnitType.AlienQueen)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanQueen)
				add_army_unit(ArmyUnit.UnitType.HumanQueen)
	for p in range(PlayerArmy.rooks):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonRook)
				add_army_unit(ArmyUnit.UnitType.DemonRook)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelRook)
				add_army_unit(ArmyUnit.UnitType.AngelRook)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienRook)
				add_army_unit(ArmyUnit.UnitType.AlienRook)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanRook)
				add_army_unit(ArmyUnit.UnitType.HumanRook)
	for p in range(PlayerArmy.bishops):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonBishop)
				add_army_unit(ArmyUnit.UnitType.DemonBishop)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelBishop)
				add_army_unit(ArmyUnit.UnitType.AngelBishop)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienBishop)
				add_army_unit(ArmyUnit.UnitType.AlienBishop)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanBishop)
				add_army_unit(ArmyUnit.UnitType.HumanBishop)
	for p in range(PlayerArmy.knights):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonKnight)
				add_army_unit(ArmyUnit.UnitType.DemonKnight)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelKnight)
				add_army_unit(ArmyUnit.UnitType.AngelKnight)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienKnight)
				add_army_unit(ArmyUnit.UnitType.AlienKnight)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanKnight)
				add_army_unit(ArmyUnit.UnitType.HumanKnight)
	for p in range(PlayerArmy.pawns):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonPawn)
				add_army_unit(ArmyUnit.UnitType.DemonPawn)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelPawn)
				add_army_unit(ArmyUnit.UnitType.AngelPawn)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienPawn)
				add_army_unit(ArmyUnit.UnitType.AlienPawn)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanPawn)
				add_army_unit(ArmyUnit.UnitType.HumanPawn)

func add_army_unit(_unit_type: ArmyUnit.UnitType):
	var new_unit = unit_instance.instantiate()
	add_child(new_unit)
	new_unit.unit_type = _unit_type
	new_unit.initialize()
	PlayerArmy.army.append(new_unit)

func deploy_unit():
	var real_position = Vector3(board.active_tile.tile_id.y * board.unit_dimension, 0.1, board.active_tile.tile_id.x * board.unit_dimension)
	active_unit.set_3d_position(real_position)
	active_unit.board_position = board.active_tile.tile_id
	active_unit.visible = true
	board.occupy_tiles(active_unit)

func handle_tile_input(tile_coord):
	print("Tile clicked: " + str(tile_coord))
	match(match_state):
		MatchState.DEPLOY:
			if(board.is_space_occupied(tile_coord, active_unit.unit_size)):
				print("space occupied, returning.")
				return
			board.select_tiles(tile_coord, active_unit.unit_size)
			admiral.speech_text.text = "Are you sure?"
			confirm_button.visible = true
		_:
			pass

func set_next_unit_for_deployment():
	active_unit = PlayerArmy.army[deploy_index]
	deploy_index += 1

func confirm_action():
	match(match_state):
		MatchState.DEPLOY:
			admiral.speech_text.text = "A fine choice!"
			deploy_unit()
			confirm_button.visible = false
			board.deselect_tiles()
			if(deploy_index == PlayerArmy.army.size()):
				admiral.speech_text.text = "Prepare to fight!"
				match_state = MatchState.BATTLE
			else:
				set_next_unit_for_deployment()
		_:
			pass
