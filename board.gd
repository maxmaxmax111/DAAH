extends Node3D
class_name GameBoard

enum BoardState {IDLE, UNIT_SELECTED, UNIT_MOVEMENT, UNIT_ATTACK}
var board_state: BoardState = BoardState.IDLE

@export var width: int = 10
@export var height: int = 10
var tiles: Array[Array] # board coordinate is denoted as (row#, column#)

func _ready():
	var temp = get_children()
	for i in range(width):
		var row = []
		for j in range(height):
			var tile = temp[i * height + j]
			row.append(tile)
		tiles.append(row)

func select_tile(board_position: Vector2i):
	tiles[board_position.x][board_position.y].select()
