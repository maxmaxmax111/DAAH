@tool
extends Node3D
class_name ArmyUnit

enum UnitType {DemonPawn, DemonKnight, DemonBishop, DemonRook, DemonQueen, AngelPawn, AngelKnight, AngelBishop, AngelRook, AngelQueen, AlienPawn, AlienKnight, AlienBishop, AlienRook, AlienQueen, HumanPawn, HumanKnight, HumanBishop, HumanRook, HumanQueen}
@export var unit_type: UnitType:
    set(value):
        unit_type = value
        update_visuals() # Call a function to handle the visual change
    get:
        return unit_type

var unit_visuals

var unit_size: int = 1
var board_position: Vector2i
var player_unit: bool = true # true for local player, false for opponent

func _ready():
    unit_visuals = get_children()

func update_visuals():
    for u in unit_visuals:
        u.visible = false
    unit_visuals[unit_type].visible = true