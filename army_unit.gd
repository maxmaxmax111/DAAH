@tool
extends Node3D
class_name ArmyUnit

enum UnitType {DemonPawn, DemonKnight, DemonBishop, DemonRook, DemonQueen, AngelPawn, AngelKnight, AngelBishop, AngelRook, AngelQueen, AlienPawn, AlienKnight, AlienBishop, AlienRook, AlienQueen, HumanPawn, HumanKnight, HumanBishop, HumanRook, HumanQueen}
@export var unit_type: UnitType:
	set(value):
		unit_type = value
		initialize(null)
	get:
		return unit_type

enum Stance {DEFEND, MOVE, ATTACK}
var stance = Stance.DEFEND

@export var demon_pawn_visual: Node3D
@export var demon_knight_visual: Node3D
@export var demon_bishop_visual: Node3D
@export var demon_rook_visual: Node3D
@export var demon_queen_visual: Node3D

@export var angel_pawn_visual: Node3D
@export var angel_knight_visual: Node3D
@export var angel_bishop_visual: Node3D
@export var angel_rook_visual: Node3D
@export var angel_queen_visual: Node3D

@export var alien_pawn_visual: Node3D
@export var alien_knight_visual: Node3D
@export var alien_bishop_visual: Node3D
@export var alien_rook_visual: Node3D
@export var alien_queen_visual: Node3D

@export var human_pawn_visual: Node3D
@export var human_knight_visual: Node3D
@export var human_bishop_visual: Node3D
@export var human_rook_visual: Node3D
@export var human_queen_visual: Node3D

var unit_size: int = 1
var board_position: Vector2i # defined by upper left tile for units that are larger than 1 tile
var player_unit: bool = true # true for local player, false for opponent
@export var unit_visuals: Array[Node3D]
var linked_panel: UnitPanel

func initialize(_unit_panel: UnitPanel):
	for u in unit_visuals:
		u.visible = false
	if(_unit_panel != null):
		linked_panel = _unit_panel
	match(unit_type):
		UnitType.DemonPawn:
			demon_pawn_visual.visible = true
			unit_size = UnitInfo.demon_pawn_size
		UnitType.DemonKnight:
			demon_knight_visual.visible = true
			unit_size = UnitInfo.demon_knight_size
		UnitType.DemonBishop:
			demon_bishop_visual.visible = true
			unit_size = UnitInfo.demon_bishop_size
		UnitType.DemonRook:
			demon_rook_visual.visible = true
			unit_size = UnitInfo.demon_rook_size
		UnitType.DemonQueen:
			demon_queen_visual.visible = true
			unit_size = UnitInfo.demon_queen_size
		UnitType.AngelPawn:
			angel_pawn_visual.visible = true
			unit_size = UnitInfo.angel_pawn_size
		UnitType.AngelKnight:
			angel_knight_visual.visible = true
			unit_size = UnitInfo.angel_knight_size
		UnitType.AngelBishop:
			angel_bishop_visual.visible = true
			unit_size = UnitInfo.angel_bishop_size
		UnitType.AngelRook:
			angel_rook_visual.visible = true
			unit_size = UnitInfo.angel_rook_size
		UnitType.AngelQueen:
			angel_queen_visual.visible = true
			unit_size = UnitInfo.angel_queen_size
		UnitType.AlienPawn:
			alien_pawn_visual.visible = true
			unit_size = UnitInfo.alien_pawn_size
		UnitType.AlienKnight:
			alien_knight_visual.visible = true
			unit_size = UnitInfo.alien_knight_size
		UnitType.AlienBishop:
			alien_bishop_visual.visible = true
			unit_size = UnitInfo.alien_bishop_size
		UnitType.AlienRook:
			alien_rook_visual.visible = true
			unit_size = UnitInfo.alien_rook_size
		UnitType.AlienQueen:
			alien_queen_visual.visible = true
			unit_size = UnitInfo.alien_queen_size
		UnitType.HumanPawn:
			human_pawn_visual.visible = true
			unit_size = UnitInfo.human_pawn_size
		UnitType.HumanKnight:
			human_knight_visual.visible = true
			unit_size = UnitInfo.human_knight_size
		UnitType.HumanBishop:
			human_bishop_visual.visible = true
			unit_size = UnitInfo.human_bishop_size
		UnitType.HumanRook:
			human_rook_visual.visible = true
			unit_size = UnitInfo.human_rook_size
		UnitType.HumanQueen:
			human_queen_visual.visible = true
			unit_size = UnitInfo.human_queen_size

func set_3d_position(new_position: Vector3):
	position = new_position