extends Node3D
class_name MatchManager

enum MatchState {DEPLOY, BATTLE, WAIT_FOR_OPPONENT, PAUSE}
var match_state: MatchState = MatchState.DEPLOY

var board: GameBoard

@export var player_unit_panel: Control
@export var unit_panel_container: Control

@export var admiral: AdmiralPanel

var unit_instance = preload("res://unit_2d.tscn")
var active_unit: ArmyUnit
func _ready():

	admiral.set_portrait()
	#admiral.speak("Deploy your units wisely, failure is not an option!")
	admiral.speak("A King may move a man, a father may claim a son, but remember that even when those who move you be Kings, or men of power, your soul is in your keeping alone.")

	GlobalSignals.tile_clicked.connect(handle_tile_input)

	for p in range(PlayerArmy.queens):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonBishop)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelBishop)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienBishop)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanBishop)
	for p in range(PlayerArmy.rooks):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonKnight)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelKnight)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienKnight)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanKnight)
	for p in range(PlayerArmy.bishops):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonBishop)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelBishop)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienBishop)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanBishop)
	for p in range(PlayerArmy.knights):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonRook)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelRook)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienRook)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanRook)
	for p in range(PlayerArmy.pawns):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				create_unit_panel(ArmyUnit.UnitType.DemonQueen)
			PlayerArmy.ArmyType.ANGELS:
				create_unit_panel(ArmyUnit.UnitType.AngelQueen)
			PlayerArmy.ArmyType.ALIENS:
				create_unit_panel(ArmyUnit.UnitType.AlienQueen)
			PlayerArmy.ArmyType.HUMANS:
				create_unit_panel(ArmyUnit.UnitType.HumanQueen)

func create_unit_panel(unit_type: ArmyUnit.UnitType):
	var new_panel = player_unit_panel.duplicate()
	unit_panel_container.add_child(new_panel)
	new_panel.initialize(unit_type)
	new_panel.visible = true

func _process(_delta):
	pass

func deploy_unit(unit_type: ArmyUnit.UnitType):
	var new_unit = unit_instance.duplicate()
	add_child(new_unit)
	new_unit.unit_type = unit_type
	var real_position = board.get_3d_position(board.active_tile.tile_id)
	new_unit.set_3d_position(real_position)
	new_unit.update_visuals(unit_type)
	new_unit.visible = true
	new_unit.board_position = board.active_tile.tile_id
	PlayerArmy.army.append(new_unit)

	board.occupy_tiles(board.active_tile, new_unit)
	board.deselect_tiles()

func handle_tile_input(tile_coord):
	match(match_state):
		MatchState.DEPLOY:
			if(board.is_space_occupied(tile_coord, active_unit.unit_size)):
				return
			board.select_tiles(tile_coord, active_unit.unit_size)
		_:
			pass