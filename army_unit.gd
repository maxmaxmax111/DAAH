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



var unit_size: int = 1
var board_position: Vector2i # defined by upper left tile for units that are larger than 1 tile
var player_unit: bool = true # true for local player, false for opponent
enum Morale {FINE, EXCITED, HOPELESS}
var morale = Morale.FINE
enum Stance {DEFEND, MOVE, ATTACK}
var stance = Stance.DEFEND
var special_ability #some special abilities are active, others are passive, some are offensive some are defensive
var move_speed: int = 0
var flying: bool = false
var attack_range: int = 0
enum AttackType {PHYSICAL, MAGICAL, EXPLOSIVE}
var attack_type: AttackType = AttackType.PHYSICAL
var is_ranged: bool = true # true for ranged attackers, false for melee
#========visual attributes
var linked_panel: UnitPanel
@export var unit_visuals: Array[Node3D]
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
#========END
func initialize(_unit_panel: UnitPanel):
	for u in unit_visuals:
		u.visible = false
	if(_unit_panel != null):
		linked_panel = _unit_panel
	match(unit_type):
		UnitType.DemonPawn:
			demon_pawn_visual.visible = true
			unit_size = UnitInfo.demon_pawn_size
			move_speed = UnitInfo.demon_pawn_move_speed
			flying = UnitInfo.demon_pawn_flying
			attack_range = UnitInfo.demon_pawn_attack_range
			attack_type = UnitInfo.demon_pawn_attack_type
			is_ranged = UnitInfo.demon_pawn_is_ranged
		UnitType.DemonKnight:
			demon_knight_visual.visible = true
			unit_size = UnitInfo.demon_knight_size
			move_speed = UnitInfo.demon_knight_move_speed
			flying = UnitInfo.demon_knight_flying
			attack_range = UnitInfo.demon_knight_attack_range
			attack_type = UnitInfo.demon_knight_attack_type
			is_ranged = UnitInfo.demon_knight_is_ranged
		UnitType.DemonBishop:
			demon_bishop_visual.visible = true
			unit_size = UnitInfo.demon_bishop_size
			move_speed = UnitInfo.demon_bishop_move_speed
			flying = UnitInfo.demon_bishop_flying
			attack_range = UnitInfo.demon_bishop_attack_range
			attack_type = UnitInfo.demon_bishop_attack_type
			is_ranged = UnitInfo.demon_bishop_is_ranged
		UnitType.DemonRook:
			demon_rook_visual.visible = true
			unit_size = UnitInfo.demon_rook_size
			move_speed = UnitInfo.demon_rook_move_speed
			flying = UnitInfo.demon_rook_flying
			attack_range = UnitInfo.demon_rook_attack_range
			attack_type = UnitInfo.demon_rook_attack_type
			is_ranged = UnitInfo.demon_rook_is_ranged
		UnitType.DemonQueen:
			demon_queen_visual.visible = true
			unit_size = UnitInfo.demon_queen_size
			move_speed = UnitInfo.demon_queen_move_speed
			flying = UnitInfo.demon_queen_flying
			attack_range = UnitInfo.demon_queen_attack_range
			attack_type = UnitInfo.demon_queen_attack_type
			is_ranged = UnitInfo.demon_queen_is_ranged
		UnitType.AngelPawn:
			angel_pawn_visual.visible = true
			unit_size = UnitInfo.angel_pawn_size
			move_speed = UnitInfo.angel_pawn_move_speed
			flying = UnitInfo.angel_pawn_flying
			attack_range = UnitInfo.angel_pawn_attack_range
			attack_type = UnitInfo.angel_pawn_attack_type
			is_ranged = UnitInfo.angel_pawn_is_ranged
		UnitType.AngelKnight:
			angel_knight_visual.visible = true
			unit_size = UnitInfo.angel_knight_size
			move_speed = UnitInfo.angel_knight_move_speed
			flying = UnitInfo.angel_knight_flying
			attack_range = UnitInfo.angel_knight_attack_range
			attack_type = UnitInfo.angel_knight_attack_type
			is_ranged = UnitInfo.angel_knight_is_ranged
		UnitType.AngelBishop:
			angel_bishop_visual.visible = true
			unit_size = UnitInfo.angel_bishop_size
			move_speed = UnitInfo.angel_bishop_move_speed
			flying = UnitInfo.angel_bishop_flying
			attack_range = UnitInfo.angel_bishop_attack_range
			attack_type = UnitInfo.angel_bishop_attack_type
			is_ranged = UnitInfo.angel_bishop_is_ranged
		UnitType.AngelRook:
			angel_rook_visual.visible = true
			unit_size = UnitInfo.angel_rook_size
			move_speed = UnitInfo.angel_rook_move_speed
			flying = UnitInfo.angel_rook_flying
			attack_range = UnitInfo.angel_rook_attack_range
			attack_type = UnitInfo.angel_rook_attack_type
			is_ranged = UnitInfo.angel_rook_is_ranged
		UnitType.AngelQueen:
			angel_queen_visual.visible = true
			unit_size = UnitInfo.angel_queen_size
			move_speed = UnitInfo.angel_queen_move_speed
			flying = UnitInfo.angel_queen_flying
			attack_range = UnitInfo.angel_queen_attack_range
			attack_type = UnitInfo.angel_queen_attack_type
			is_ranged = UnitInfo.angel_queen_is_ranged
		UnitType.AlienPawn:
			alien_pawn_visual.visible = true
			unit_size = UnitInfo.alien_pawn_size
			move_speed = UnitInfo.alien_pawn_move_speed
			flying = UnitInfo.alien_pawn_flying
			attack_range = UnitInfo.alien_pawn_attack_range
			attack_type = UnitInfo.alien_pawn_attack_type
			is_ranged = UnitInfo.alien_pawn_is_ranged
		UnitType.AlienKnight:
			alien_knight_visual.visible = true
			unit_size = UnitInfo.alien_knight_size
			move_speed = UnitInfo.alien_knight_move_speed
			flying = UnitInfo.alien_knight_flying
			attack_range = UnitInfo.alien_knight_attack_range
			attack_type = UnitInfo.alien_knight_attack_type
			is_ranged = UnitInfo.alien_knight_is_ranged
		UnitType.AlienBishop:
			alien_bishop_visual.visible = true
			unit_size = UnitInfo.alien_bishop_size
			move_speed = UnitInfo.alien_bishop_move_speed
			flying = UnitInfo.alien_bishop_flying
			attack_range = UnitInfo.alien_bishop_attack_range
			attack_type = UnitInfo.alien_bishop_attack_type
			is_ranged = UnitInfo.alien_bishop_is_ranged
		UnitType.AlienRook:
			alien_rook_visual.visible = true
			unit_size = UnitInfo.alien_rook_size
			move_speed = UnitInfo.alien_rook_move_speed
			flying = UnitInfo.alien_rook_flying
			attack_range = UnitInfo.alien_rook_attack_range
			attack_type = UnitInfo.alien_rook_attack_type
			is_ranged = UnitInfo.alien_rook_is_ranged
		UnitType.AlienQueen:
			alien_queen_visual.visible = true
			unit_size = UnitInfo.alien_queen_size
			move_speed = UnitInfo.alien_queen_move_speed
			flying = UnitInfo.alien_queen_flying
			attack_range = UnitInfo.alien_queen_attack_range
			attack_type = UnitInfo.alien_queen_attack_type
			is_ranged = UnitInfo.alien_queen_is_ranged
		UnitType.HumanPawn:
			human_pawn_visual.visible = true
			unit_size = UnitInfo.human_pawn_size
			move_speed = UnitInfo.human_pawn_move_speed
			flying = UnitInfo.human_pawn_flying
			attack_range = UnitInfo.human_pawn_attack_range
			attack_type = UnitInfo.human_pawn_attack_type
			is_ranged = UnitInfo.human_pawn_is_ranged
		UnitType.HumanKnight:
			human_knight_visual.visible = true
			unit_size = UnitInfo.human_knight_size
			move_speed = UnitInfo.human_knight_move_speed
			flying = UnitInfo.human_knight_flying
			attack_range = UnitInfo.human_knight_attack_range
			attack_type = UnitInfo.human_knight_attack_type
			is_ranged = UnitInfo.human_knight_is_ranged
		UnitType.HumanBishop:
			human_bishop_visual.visible = true
			unit_size = UnitInfo.human_bishop_size
			move_speed = UnitInfo.human_bishop_move_speed
			flying = UnitInfo.human_bishop_flying
			attack_range = UnitInfo.human_bishop_attack_range
			attack_type = UnitInfo.human_bishop_attack_type
			is_ranged = UnitInfo.human_bishop_is_ranged
		UnitType.HumanRook:
			human_rook_visual.visible = true
			unit_size = UnitInfo.human_rook_size
			move_speed = UnitInfo.human_rook_move_speed
			flying = UnitInfo.human_rook_flying
			attack_range = UnitInfo.human_rook_attack_range
			attack_type = UnitInfo.human_rook_attack_type
			is_ranged = UnitInfo.human_rook_is_ranged
		UnitType.HumanQueen:
			human_queen_visual.visible = true
			unit_size = UnitInfo.human_queen_size
			move_speed = UnitInfo.human_queen_move_speed
			flying = UnitInfo.human_queen_flying
			attack_range = UnitInfo.human_queen_attack_range
			attack_type = UnitInfo.human_queen_attack_type
			is_ranged = UnitInfo.human_queen_is_ranged

func set_3d_position(new_position: Vector3):
	position = new_position