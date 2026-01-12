@tool
extends Node3D
class_name ArmyUnit

enum UnitType {DemonPawn, DemonKnight, DemonBishop, DemonRook, DemonQueen, AngelPawn, AngelKnight, AngelBishop, AngelRook, AngelQueen, AlienPawn, AlienKnight, AlienBishop, AlienRook, AlienQueen, HumanPawn, HumanKnight, HumanBishop, HumanRook, HumanQueen}
@export var unit_type: UnitType:
	set(value):
		unit_type = value
		update_visuals()
	get:
		return unit_type

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

func update_visuals():
	for u in unit_visuals:
		u.visible = false
	match(unit_type):
		UnitType.DemonPawn:
			demon_pawn_visual.visible = true
		UnitType.DemonKnight:
			demon_knight_visual.visible = true
		UnitType.DemonBishop:
			demon_bishop_visual.visible = true
		UnitType.DemonRook:
			demon_rook_visual.visible = true
		UnitType.DemonQueen:
			demon_queen_visual.visible = true
		UnitType.AngelPawn:
			angel_pawn_visual.visible = true
		UnitType.AngelKnight:
			angel_knight_visual.visible = true
		UnitType.AngelBishop:
			angel_bishop_visual.visible = true
		UnitType.AngelRook:
			angel_rook_visual.visible = true
		UnitType.AngelQueen:
			angel_queen_visual.visible = true
		UnitType.AlienPawn:
			alien_pawn_visual.visible = true
		UnitType.AlienKnight:
			alien_knight_visual.visible = true
		UnitType.AlienBishop:
			alien_bishop_visual.visible = true
		UnitType.AlienRook:
			alien_rook_visual.visible = true
		UnitType.AlienQueen:
			alien_queen_visual.visible = true
		UnitType.HumanPawn:
			human_pawn_visual.visible = true
		UnitType.HumanKnight:
			human_knight_visual.visible = true
		UnitType.HumanBishop:
			human_bishop_visual.visible = true
		UnitType.HumanRook:
			human_rook_visual.visible = true
		UnitType.HumanQueen:
			human_queen_visual.visible = true

func set_3d_position(new_position: Vector3):
	position = new_position