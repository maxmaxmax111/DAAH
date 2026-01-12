extends Node3D
class_name GameBoard

enum BoardState {IDLE, DEPLOY, UNIT_SELECTED, UNIT_MOVEMENT, UNIT_ATTACK}
var board_state: BoardState = BoardState.IDLE


@export var width: int = 10
@export var height: int = 10
@export var unit_dimension: float = 1.0
@export var board_thickness: float = 0.2
var tiles: Array[Array] # board coordinate is denoted as (row#, column#)
var selected_tiles: Array[BoardTile]
var highlighted_tiles: Array[BoardTile]
var selected_unit: ArmyUnit

func _ready():
	var temp = get_children()
	for i in range(width):
		var row = []
		for j in range(height):
			var tile = temp[i * height + j]
			row.append(tile)
		tiles.append(row)

func select_tile(board_position: Vector2i):
	var selected_tile = tiles[board_position.x][board_position.y] as BoardTile
	match board_state:
		BoardState.DEPLOY:
			return
		BoardState.IDLE:
			if(!selected_tile.occupied):
				return
			if(selected_tile.occupied_by.player_unit):
				selected_unit = selected_tile.occupied_by
			else:
				return
			selected_tiles.append(tiles[selected_unit.board_position.x][selected_unit.board_position.y])
			if(selected_unit.unit_size > 1):
				selected_tiles.append(tiles[selected_unit.board_position.x][selected_unit.board_position.y+1])
				selected_tiles.append(tiles[selected_unit.board_position.x+1][selected_unit.board_position.y])
				selected_tiles.append(tiles[selected_unit.board_position.x+1][selected_unit.board_position.y+1])
				if(selected_unit.unit_size > 2):
					selected_tiles.append(tiles[selected_unit.board_position.x][selected_unit.board_position.y+2])
					selected_tiles.append(tiles[selected_unit.board_position.x+1][selected_unit.board_position.y+2])
					selected_tiles.append(tiles[selected_unit.board_position.x+2][selected_unit.board_position.y])
					selected_tiles.append(tiles[selected_unit.board_position.x+2][selected_unit.board_position.y+1])
					selected_tiles.append(tiles[selected_unit.board_position.x+2][selected_unit.board_position.y+2])
			for t in selected_tiles:
				t.select_tile()

		BoardState.UNIT_SELECTED:
			return
		BoardState.UNIT_MOVEMENT:
			return
		BoardState.UNIT_ATTACK:
			return

func get_3d_position(coord: Vector2i):
	var x_pos = coord.y * unit_dimension
	var y_pos = coord.x * unit_dimension
	return Vector3(x_pos,position.y+board_thickness,y_pos)