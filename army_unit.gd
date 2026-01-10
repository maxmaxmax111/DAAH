extends Node3D
class_name ArmyUnit

enum UnitType {DemonPawn, DemonKnight, DemonBishop, DemonRook, DemonQueen, AngelPawn, AngelKnight, AngelBishop, AngelRook, AngelQueen, AlienPawn, AlienKnight, AlienBishop, AlienRook, AlienQueen, HumanPawn, HumanKnight, HumanBishop, HumanRook, HumanQueen}
@export var unit_type: UnitType

var unit_size: int = 1
var board_position: Vector2i # defined by upper left tile for units that are larger than 1 tile
var player_unit: bool = true # true for local player, false for opponent