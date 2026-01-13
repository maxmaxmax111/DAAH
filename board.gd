extends Node3D
class_name GameBoard

enum BoardState {IDLE, DEPLOY, UNIT_SELECTED, UNIT_MOVEMENT, UNIT_ATTACK}
var board_state: BoardState = BoardState.IDLE


@export var width: int = 10
@export var height: int = 10
@export var unit_dimension: float = 1.0
@export var board_thickness: float = 0.2
var tiles: Array[Array] # board coordinate is denoted as (row#, column#)
var active_tile: BoardTile
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

func select_tiles(coord: Vector2i, selection_size: int = 1):
	active_tile = tiles[coord.x][coord.y]
	deselect_tiles()
	selected_tiles = get_tile_group(coord, selection_size)
	if(selected_tiles == null):
		return false
	else:
		for s in selected_tiles:
			s.highlight()
		return true

func deselect_tiles():
	if(selected_tiles.size() > 0):
		for s in selected_tiles:
			s.deselect_tile()
		selected_tiles.clear()

func get_3d_position(coord: Vector2i):
	var x_pos = coord.y * unit_dimension
	var y_pos = coord.x * unit_dimension
	return Vector3(x_pos,position.y+board_thickness,y_pos)

func is_space_occupied(coord: Vector2i, space_size: int):#also checks to make sure selection can't be out of bounds (for units with size > 1)
	if(is_selection_out_of_bounds(coord, space_size)):
		return true
	var space_occupied = false
	var tile_group = get_tile_group(coord, space_size)
	for t in tile_group:
		if(t.occupied):
			space_occupied = true
	return space_occupied

func get_tile_group(coord: Vector2i, group_size: int):
	if(group_size > 1 && is_selection_out_of_bounds(coord, group_size)):
		return null
	var tile_group: Array[BoardTile]
	tile_group.append(tiles[coord.x][coord.y])
	if(group_size > 1):
		tile_group.append(tiles[coord.x][coord.y+1])
		tile_group.append(tiles[coord.x+1][coord.y])
		tile_group.append(tiles[coord.x+1][coord.y+1])
	if(group_size > 2):
		tile_group.append(tiles[coord.x][coord.y+2])
		tile_group.append(tiles[coord.x+1][coord.y+2])
		tile_group.append(tiles[coord.x+2][coord.y])
		tile_group.append(tiles[coord.x+2][coord.y+1])
		tile_group.append(tiles[coord.x+2][coord.y+2])
	return tile_group

func occupy_tiles(occupying_unit: ArmyUnit):
	var tile_group = get_tile_group(occupying_unit.board_position, occupying_unit.unit_size)
	for t in tile_group:
		t.occupy_tile(occupying_unit)

func is_selection_out_of_bounds(_coord, _group_size):
	if(_coord.x + _group_size - 1 >= height):
		return true
	elif(_coord.y + _group_size - 1 >= width):
		return true
	else:
		return false