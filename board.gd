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
var pending_move_destinations: Array[Dictionary] # Stores {position, unit_size} for units with confirmed move orders
var potential_attack_tiles: Array[BoardTile]
var attack_target_tile: Vector2i = Vector2i(-1, -1)
var all_attack_targets: Array[Vector2i] # Stores all confirmed attack targets
var selected_unit: ArmyUnit

@export var movement_path_color: Color = Color.BLUE
@export var attack_range_color: Color = Color.RED
@export var attack_target_color: Color = Color.DARK_RED
@export var attack_projectile_color: Color = Color.MAROON
@export var attack_step_delay: float = 0.1

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
					# Also check against pending move destinations from this turn
					if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit) and not is_space_reserved_by_pending_move(next_pos, unit.unit_size):
						reachable.append(next_pos)
			else:
				# Grounded units need each step clear (excluding itself)
				# Also check against pending move destinations from this turn
				if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit) and not is_space_reserved_by_pending_move(next_pos, unit.unit_size):
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

func is_space_reserved_by_pending_move(coord: Vector2i, space_size: int) -> bool:
	# Check if the given position would overlap with any pending move destinations
	for pending in pending_move_destinations:
		var pending_pos: Vector2i = pending["position"]
		var pending_size: int = pending["unit_size"]

		# Check for overlap between the two unit spaces
		var coord_right = coord.y + space_size
		var coord_bottom = coord.x + space_size
		var pending_right = pending_pos.y + pending_size
		var pending_bottom = pending_pos.x + pending_size

		# No overlap if one is completely to the side of the other
		if coord.y >= pending_right or pending_pos.y >= coord_right:
			continue
		if coord.x >= pending_bottom or pending_pos.x >= coord_bottom:
			continue

		# Overlap detected
		return true

	return false

func add_pending_move_destination(dest_position: Vector2i, unit_size: int):
	pending_move_destinations.append({"position": dest_position, "unit_size": unit_size})

func clear_pending_move_destinations():
	pending_move_destinations.clear()

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
				# Also check against pending move destinations from this turn
				if not is_space_occupied_by_friendly(next_pos, unit.unit_size, unit.player_unit, unit) and not is_space_reserved_by_pending_move(next_pos, unit.unit_size):
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

func highlight_attack_range(unit: ArmyUnit):
	clear_potential_attacks()
	var attackable_tiles = calculate_attack_tiles(unit)
	for tile_coord in attackable_tiles:
		var tile = get_tile(tile_coord)
		var mat = tile.get_active_material(0).duplicate()
		mat.albedo_color = attack_range_color
		tile.set_surface_override_material(0, mat)
		tile.update_shade()
		potential_attack_tiles.append(tile)

func calculate_attack_tiles(unit: ArmyUnit) -> Array[Vector2i]:
	var attackable: Array[Vector2i] = []
	var start_pos = unit.board_position
	var attack_range = unit.attack_range
	var unit_size = unit.unit_size
	var added_tiles: Dictionary = {} # Track added tiles to avoid duplicates

	if unit_size == 1:
		# Size 1 unit: center is the tile itself
		# 8 directions: cardinal + diagonal
		var directions = [
			Vector2i(0, 1),   # right
			Vector2i(0, -1),  # left
			Vector2i(1, 0),   # down
			Vector2i(-1, 0),  # up
			Vector2i(1, 1),   # down-right
			Vector2i(1, -1),  # down-left
			Vector2i(-1, 1),  # up-right
			Vector2i(-1, -1)  # up-left
		]

		for direction in directions:
			for dist in range(1, attack_range + 1):
				var target_pos = start_pos + direction * dist

				# Check bounds
				if target_pos.x < 0 or target_pos.x >= height or target_pos.y < 0 or target_pos.y >= width:
					break

				if not added_tiles.has(target_pos):
					attackable.append(target_pos)
					added_tiles[target_pos] = true

	elif unit_size == 2:
		# Size 2 unit: center is at corner joining 4 tiles
		# The center is at (start_pos.x + 1, start_pos.y + 1) corner
		# Cardinal directions use "thick" lines (2 tiles wide)
		# Diagonal directions emanate from the 4 corner tiles

		# Cardinal directions with thick lines
		# Right (from column start_pos.y + 2, rows start_pos.x and start_pos.x + 1)
		for dist in range(1, attack_range + 1):
			var col = start_pos.y + 1 + dist
			for row_offset in range(2):
				var target_pos = Vector2i(start_pos.x + row_offset, col)
				if target_pos.y >= 0 and target_pos.y < width and target_pos.x >= 0 and target_pos.x < height:
					if not added_tiles.has(target_pos):
						attackable.append(target_pos)
						added_tiles[target_pos] = true

		# Left (from column start_pos.y - 1, rows start_pos.x and start_pos.x + 1)
		for dist in range(1, attack_range + 1):
			var col = start_pos.y - dist
			for row_offset in range(2):
				var target_pos = Vector2i(start_pos.x + row_offset, col)
				if target_pos.y >= 0 and target_pos.y < width and target_pos.x >= 0 and target_pos.x < height:
					if not added_tiles.has(target_pos):
						attackable.append(target_pos)
						added_tiles[target_pos] = true

		# Down (from row start_pos.x + 2, columns start_pos.y and start_pos.y + 1)
		for dist in range(1, attack_range + 1):
			var row = start_pos.x + 1 + dist
			for col_offset in range(2):
				var target_pos = Vector2i(row, start_pos.y + col_offset)
				if target_pos.y >= 0 and target_pos.y < width and target_pos.x >= 0 and target_pos.x < height:
					if not added_tiles.has(target_pos):
						attackable.append(target_pos)
						added_tiles[target_pos] = true

		# Up (from row start_pos.x - 1, columns start_pos.y and start_pos.y + 1)
		for dist in range(1, attack_range + 1):
			var row = start_pos.x - dist
			for col_offset in range(2):
				var target_pos = Vector2i(row, start_pos.y + col_offset)
				if target_pos.y >= 0 and target_pos.y < width and target_pos.x >= 0 and target_pos.x < height:
					if not added_tiles.has(target_pos):
						attackable.append(target_pos)
						added_tiles[target_pos] = true

		# Diagonal directions from the 4 corner tiles
		var corners = [
			Vector2i(start_pos.x, start_pos.y),         # top-left corner
			Vector2i(start_pos.x, start_pos.y + 1),     # top-right corner
			Vector2i(start_pos.x + 1, start_pos.y),     # bottom-left corner
			Vector2i(start_pos.x + 1, start_pos.y + 1)  # bottom-right corner
		]
		var diagonal_dirs = [
			Vector2i(-1, -1),  # up-left (from top-left corner)
			Vector2i(-1, 1),   # up-right (from top-right corner)
			Vector2i(1, -1),   # down-left (from bottom-left corner)
			Vector2i(1, 1)     # down-right (from bottom-right corner)
		]

		for i in range(4):
			var corner = corners[i]
			var direction = diagonal_dirs[i]
			for dist in range(1, attack_range + 1):
				var target_pos = corner + direction * dist

				# Check bounds
				if target_pos.x < 0 or target_pos.x >= height or target_pos.y < 0 or target_pos.y >= width:
					break

				if not added_tiles.has(target_pos):
					attackable.append(target_pos)
					added_tiles[target_pos] = true

	return attackable

func highlight_attack_target(tile_coord: Vector2i):
	clear_attack_target()
	attack_target_tile = tile_coord
	var tile = get_tile(tile_coord)
	var mat = tile.get_active_material(0).duplicate()
	mat.albedo_color = attack_target_color
	tile.set_surface_override_material(0, mat)
	tile.update_shade()

func confirm_attack_target():
	# Store the current attack target and keep it highlighted
	if attack_target_tile != Vector2i(-1, -1):
		all_attack_targets.append(attack_target_tile)
		attack_target_tile = Vector2i(-1, -1)

func clear_attack_target():
	if attack_target_tile != Vector2i(-1, -1):
		var tile = get_tile(attack_target_tile)
		# Check if this tile is still in potential_attack_tiles
		var is_potential_attack = false
		for potential_tile in potential_attack_tiles:
			if potential_tile.tile_id == attack_target_tile:
				is_potential_attack = true
				break

		# If it's a potential attack tile, re-highlight it with attack range color; otherwise deselect it
		if is_potential_attack:
			var mat = tile.get_active_material(0).duplicate()
			mat.albedo_color = attack_range_color
			tile.set_surface_override_material(0, mat)
			tile.update_shade()
		else:
			tile.deselect_tile()
		attack_target_tile = Vector2i(-1, -1)

func clear_potential_attacks():
	for tile in potential_attack_tiles:
		# Check if this tile is part of a confirmed attack target
		var is_confirmed_target = false
		for target in all_attack_targets:
			if tile.tile_id == target:
				is_confirmed_target = true
				break

		# Only deselect if not a confirmed target
		if not is_confirmed_target:
			tile.deselect_tile()
	potential_attack_tiles.clear()

func clear_all_attack_targets():
	# Clear the current attack target
	clear_attack_target()
	# Clear all confirmed attack targets
	for target in all_attack_targets:
		var tile = get_tile(target)
		tile.deselect_tile()
	all_attack_targets.clear()

func highlight_attack_projectile(tile_coord: Vector2i):
	var tile = get_tile(tile_coord)
	var mat = tile.get_active_material(0).duplicate()
	mat.albedo_color = attack_projectile_color
	tile.set_surface_override_material(0, mat)
	tile.update_shade()

func clear_attack_projectile(tile_coord: Vector2i):
	var tile = get_tile(tile_coord)
	tile.deselect_tile()

func calculate_attack_path(attacker_pos: Vector2i, target_pos: Vector2i, attacker_size: int) -> Array[Vector2i]:
	# Calculate the path from attacker to target in a straight line
	var path: Array[Vector2i] = []

	# Determine the direction
	var diff = target_pos - attacker_pos
	var direction = Vector2i(sign(diff.x), sign(diff.y))

	# For size 2 units, find the starting position based on direction
	var start_pos = attacker_pos
	if attacker_size == 2:
		# Adjust starting position based on direction
		if direction.x > 0:
			start_pos.x += 1
		if direction.y > 0:
			start_pos.y += 1

	# Build the path from start to target
	var current_pos = start_pos + direction
	while current_pos != target_pos + direction:
		if current_pos.x < 0 or current_pos.x >= height or current_pos.y < 0 or current_pos.y >= width:
			break
		path.append(current_pos)
		current_pos = current_pos + direction

	return path

func get_unit_on_tile(tile_coord: Vector2i) -> ArmyUnit:
	if tile_coord.x < 0 or tile_coord.x >= height or tile_coord.y < 0 or tile_coord.y >= width:
		return null
	var tile = get_tile(tile_coord)
	if tile.occupied and tile.occupied_by != null:
		return tile.occupied_by
	return null