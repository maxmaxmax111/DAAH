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
var potential_move_tiles: Array[BoardTile]
var movement_path: Array[Vector2i]
var all_movement_paths: Array[Array] # Stores all confirmed movement paths
var selected_unit: ArmyUnit

@export var movement_path_color: Color = Color.BLUE

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

func free_tiles(tile_position: Vector2i, size: int):
	var tile_group = get_tile_group(tile_position, size)
	if tile_group != null:
		for t in tile_group:
			t.free_tile()

func is_selection_out_of_bounds(_coord, _group_size):
	if(_coord.x + _group_size - 1 >= height):
		return true
	elif(_coord.y + _group_size - 1 >= width):
		return true
	else:
		return false

func get_tile(_coord: Vector2i):
	return tiles[_coord.x][_coord.y]

func highlight_potential_moves(unit: ArmyUnit):
	clear_potential_moves()
	var reachable_tiles = calculate_reachable_tiles(unit)
	for tile_coord in reachable_tiles:
		var tile = get_tile(tile_coord)
		tile.highlight()
		potential_move_tiles.append(tile)

func clear_potential_moves():
	for tile in potential_move_tiles:
		# Check if this tile is part of a confirmed movement path
		var is_in_confirmed_path = false
		for path in all_movement_paths:
			for tile_coord in path:
				if tile.tile_id == tile_coord:
					is_in_confirmed_path = true
					break
			if is_in_confirmed_path:
				break

		# Only deselect if not part of a confirmed path
		if not is_in_confirmed_path:
			tile.deselect_tile()
	potential_move_tiles.clear()

func calculate_reachable_tiles(unit: ArmyUnit) -> Array[Vector2i]:
	var reachable: Array[Vector2i] = []
	var start_pos = unit.board_position

	# Use BFS to find all reachable tiles
	var queue: Array = [[start_pos, 0]] # [position, distance]
	var visited: Dictionary = {start_pos: true}

	while queue.size() > 0:
		var current = queue.pop_front()
		var pos: Vector2i = current[0]
		var dist: int = current[1]

		if dist >= unit.move_speed:
			continue

		# Check all cardinal directions
		var directions = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
		for direction in directions:
			var next_pos = pos + direction

			# Check bounds
			if next_pos.x < 0 or next_pos.x >= height or next_pos.y < 0 or next_pos.y >= width:
				continue

			# Skip if already visited
			if visited.has(next_pos):
				continue

			# Check if path is blocked
			if unit.flying:
				# Flying units move as if all tiles are unobstructed
				# Only restriction: final position must be clear of friendly units
				if not visited.has(next_pos):
					visited[next_pos] = true
					queue.append([next_pos, dist + 1])

					# Check if this could be a final position (reachable destination)
					# Final position must not be occupied by friendly units (excluding itself)
					if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit):
						reachable.append(next_pos)
			else:
				# Grounded units need each step clear (excluding itself)
				if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit):
					if not visited.has(next_pos):
						reachable.append(next_pos)
						visited[next_pos] = true
						queue.append([next_pos, dist + 1])

	return reachable

func is_space_occupied_by_friendly(coord: Vector2i, space_size: int, is_player_unit: bool, exclude_unit: ArmyUnit = null) -> bool:
	if is_selection_out_of_bounds(coord, space_size):
		return true

	var tile_group = get_tile_group(coord, space_size)
	if tile_group == null:
		return true

	for t in tile_group:
		if t.occupied and t.occupied_by != null:
			# Skip if this is the unit we're excluding (the moving unit itself)
			if exclude_unit != null and t.occupied_by == exclude_unit:
				continue
			# Check if occupied by friendly unit
			if t.occupied_by.player_unit == is_player_unit:
				return true

	return false

func is_space_occupied_by_enemy_flying(coord: Vector2i, space_size: int, is_player_unit: bool) -> bool:
	if is_selection_out_of_bounds(coord, space_size):
		return false

	var tile_group = get_tile_group(coord, space_size)
	if tile_group == null:
		return false

	for t in tile_group:
		if t.occupied and t.occupied_by != null:
			# Check if occupied by enemy flying unit
			if t.occupied_by.player_unit != is_player_unit and t.occupied_by.flying:
				return true

	return false

func calculate_path(from: Vector2i, to: Vector2i, unit: ArmyUnit) -> Array[Vector2i]:
	var path: Array[Vector2i] = []

	# Simple pathfinding using BFS
	var queue: Array = [[from, [from]]]
	var visited: Dictionary = {from: true}

	while queue.size() > 0:
		var current = queue.pop_front()
		var pos: Vector2i = current[0]
		var current_path: Array = current[1]

		if pos == to:
			# Convert to typed array
			for coord in current_path:
				path.append(coord)
			break

		var directions = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
		for direction in directions:
			var next_pos = pos + direction

			if next_pos.x < 0 or next_pos.x >= height or next_pos.y < 0 or next_pos.y >= width:
				continue

			if visited.has(next_pos):
				continue

			# Check if this tile is reachable based on unit type
			if unit.flying:
				# Flying units can path through all tiles (no obstruction checks)
				visited[next_pos] = true
				var new_path = current_path.duplicate()
				new_path.append(next_pos)
				queue.append([next_pos, new_path])
			else:
				# Grounded units need clear path (excluding itself)
				if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit):
					visited[next_pos] = true
					var new_path = current_path.duplicate()
					new_path.append(next_pos)
					queue.append([next_pos, new_path])

	return path

func highlight_movement_path(path: Array[Vector2i]):
	clear_movement_path()
	movement_path = path.duplicate()
	for tile_coord in path:
		var tile = get_tile(tile_coord)
		var mat = tile.get_active_material(0).duplicate()
		mat.albedo_color = movement_path_color
		tile.set_surface_override_material(0, mat)
		tile.update_shade()

func confirm_movement_path():
	# Store the current movement path and keep it highlighted
	if movement_path.size() > 0:
		all_movement_paths.append(movement_path.duplicate())
		movement_path.clear()

func clear_movement_path():
	for tile_coord in movement_path:
		var tile = get_tile(tile_coord)
		# Check if this tile is still in potential_move_tiles
		var is_potential_move = false
		for potential_tile in potential_move_tiles:
			if potential_tile.tile_id == tile_coord:
				is_potential_move = true
				break

		# If it's a potential move tile, re-highlight it; otherwise deselect it
		if is_potential_move:
			tile.highlight()
		else:
			tile.deselect_tile()
	movement_path.clear()

func clear_all_movement_paths():
	# Clear the current movement path
	clear_movement_path()
	# Clear all confirmed movement paths
	for path in all_movement_paths:
		for tile_coord in path:
			var tile = get_tile(tile_coord)
			tile.deselect_tile()
	all_movement_paths.clear()