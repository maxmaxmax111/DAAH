extends Node3D
class_name MatchManager

enum MatchState {DEPLOY, BATTLE}
var match_state: MatchState = MatchState.DEPLOY

var board: GameBoard

@export var player_unit_panel: Control
@export var unit_panel_container: Control

var player_units: Array[ArmyUnit]
@export var admiral: AdmiralPanel

func _ready():
	admiral.set_portrait()
	admiral.speak("Deploy your units wisely, failure is not an option!")
	for p in range(PlayerArmy.queens):
		var new_queen = player_unit_panel.duplicate()
		unit_panel_container.add_child(new_queen)
		new_queen.supply_cost.text = "9"
		new_queen.unit_size.text = "3"
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				new_queen.unit_portrait.texture = UnitInfo.demon_queen_portrait
				new_queen.unit_name.text = UnitInfo.demon_queen_name
			PlayerArmy.ArmyType.ANGELS:
				new_queen.unit_portrait.texture = UnitInfo.angel_queen_portrait
				new_queen.unit_name.text = UnitInfo.angel_queen_name
			PlayerArmy.ArmyType.ALIENS:
				new_queen.unit_portrait.texture = UnitInfo.alien_queen_portrait
				new_queen.unit_name.text = UnitInfo.alien_queen_name
			PlayerArmy.ArmyType.HUMANS:
				new_queen.unit_portrait.texture = UnitInfo.human_queen_portrait
				new_queen.unit_name.text = UnitInfo.human_queen_name
		new_queen.visible = true
	for p in range(PlayerArmy.rooks):
		var new_rook = player_unit_panel.duplicate()
		unit_panel_container.add_child(new_rook)
		new_rook.supply_cost.text = "5"
		new_rook.unit_size.text = "2"
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				new_rook.unit_portrait.texture = UnitInfo.demon_rook_portrait
				new_rook.unit_name.text = UnitInfo.demon_rook_name
			PlayerArmy.ArmyType.ANGELS:
				new_rook.unit_portrait.texture = UnitInfo.angel_rook_portrait
				new_rook.unit_name.text = UnitInfo.angel_rook_name
			PlayerArmy.ArmyType.ALIENS:
				new_rook.unit_portrait.texture = UnitInfo.alien_rook_portrait
				new_rook.unit_name.text = UnitInfo.alien_rook_name
			PlayerArmy.ArmyType.HUMANS:
				new_rook.unit_portrait.texture = UnitInfo.human_rook_portrait
				new_rook.unit_name.text = UnitInfo.human_rook_name
		new_rook.visible = true
	for p in range(PlayerArmy.bishops):
		var new_bishop = player_unit_panel.duplicate()
		unit_panel_container.add_child(new_bishop)
		new_bishop.supply_cost.text = "3"
		new_bishop.unit_size.text = "1"
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				new_bishop.unit_portrait.texture = UnitInfo.demon_bishop_portrait
				new_bishop.unit_name.text = UnitInfo.demon_bishop_name
			PlayerArmy.ArmyType.ANGELS:
				new_bishop.unit_portrait.texture = UnitInfo.angel_bishop_portrait
				new_bishop.unit_name.text = UnitInfo.angel_bishop_name
			PlayerArmy.ArmyType.ALIENS:
				new_bishop.unit_portrait.texture = UnitInfo.alien_bishop_portrait
				new_bishop.unit_name.text = UnitInfo.alien_bishop_name
			PlayerArmy.ArmyType.HUMANS:
				new_bishop.unit_portrait.texture = UnitInfo.human_bishop_portrait
				new_bishop.unit_name.text = UnitInfo.human_bishop_name
		new_bishop.visible = true
	for p in range(PlayerArmy.knights):
		var new_knight = player_unit_panel.duplicate()
		unit_panel_container.add_child(new_knight)
		new_knight.supply_cost.text = "2"
		new_knight.unit_size.text = "1"
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				new_knight.unit_portrait.texture = UnitInfo.demon_knight_portrait
				new_knight.unit_name.text = UnitInfo.demon_knight_name
			PlayerArmy.ArmyType.ANGELS:
				new_knight.unit_portrait.texture = UnitInfo.angel_knight_portrait
				new_knight.unit_name.text = UnitInfo.angel_knight_name
			PlayerArmy.ArmyType.ALIENS:
				new_knight.unit_portrait.texture = UnitInfo.alien_knight_portrait
				new_knight.unit_name.text = UnitInfo.alien_knight_name
			PlayerArmy.ArmyType.HUMANS:
				new_knight.unit_portrait.texture = UnitInfo.human_knight_portrait
				new_knight.unit_name.text = UnitInfo.human_knight_name
		new_knight.visible = true
	for p in range(PlayerArmy.pawns):
		var new_pawn = player_unit_panel.duplicate()
		unit_panel_container.add_child(new_pawn)
		new_pawn.supply_cost.text = "1"
		new_pawn.unit_size.text = "1"
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				new_pawn.unit_portrait.texture = UnitInfo.demon_pawn_portrait
				new_pawn.unit_name.text = UnitInfo.demon_pawn_name
			PlayerArmy.ArmyType.ANGELS:
				new_pawn.unit_portrait.texture = UnitInfo.angel_pawn_portrait
				new_pawn.unit_name.text = UnitInfo.angel_pawn_name
			PlayerArmy.ArmyType.ALIENS:
				new_pawn.unit_portrait.texture = UnitInfo.alien_pawn_portrait
				new_pawn.unit_name.text = UnitInfo.alien_pawn_name
			PlayerArmy.ArmyType.HUMANS:
				new_pawn.unit_portrait.texture = UnitInfo.human_pawn_portrait
				new_pawn.unit_name.text = UnitInfo.human_pawn_name
		new_pawn.visible = true

func _process(_delta):
	pass
