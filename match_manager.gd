extends Node3D
class_name MatchManager

enum MatchState {DEPLOY, BATTLE, WAIT_FOR_OPPONENT, PAUSE}
var match_state: MatchState = MatchState.DEPLOY

enum DeployTurn {PLAYER, OPPONENT}
var current_deploy_turn: DeployTurn = DeployTurn.PLAYER
var pending_deployment: Dictionary = {} # Stores unit and position for hidden deployment

@export var board: GameBoard
@export var deployment_rows: int = 4  # Number of rows from bottom edge where units can be deployed

@export var player_unit_panel: Control
@export var unit_panel_container: Control

@export var admiral: AdmiralPanel

@export var confirm_button: Button
@export var attack_button: Button
@export var move_button: Button
@export var end_turn_button: Button

var unit_instance = preload("res://unit_2d.tscn")
var active_unit: ArmyUnit
var deploy_index: int = 0

# Turn and order tracking
var orders_issued: int = 0
var max_orders_per_turn: int = 2
var pending_move_order: Dictionary = {} # Stores unit and target position
var confirmed_orders: Array[Dictionary] = [] # Stores all confirmed orders for this turn
var move_step_delay: float = 0.25 # Time to pause between each movement step

# Opponent army variables
var opponent_army_type: PlayerArmy.ArmyType
var opponent_army: Array[ArmyUnit]
var opponent_deploy_index: int = 0
var opponent_active_unit: ArmyUnit
func _ready():
	admiral.set_portrait()
	#admiral.speak("Deploy your units wisely, failure is not an option!")
	admiral.speak("A King may move a man, a father may claim a son, but remember that even when those who move you be Kings, or men of power, your soul is in your keeping alone.")
	GlobalSignals.tile_clicked.connect(handle_tile_input)
	confirm_button.button_up.connect(confirm_action)
	attack_button.button_up.connect(set_attack_stance)
	move_button.button_up.connect(set_move_stance)
	end_turn_button.button_up.connect(end_turn)
	build_army()
	draft_opponent_army()
	sort_armies_by_supply_cost()
	set_next_unit_for_deployment()
func create_unit_panel(unit_type: ArmyUnit.UnitType):
	var new_panel = player_unit_panel.duplicate()
	unit_panel_container.add_child(new_panel)
	new_panel.initialize(unit_type)
	return new_panel

func _process(_delta):
	pass

func build_army():
	for p in range(PlayerArmy.queens):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.DemonQueen)
				add_army_unit(ArmyUnit.UnitType.DemonQueen, new_panel)
			PlayerArmy.ArmyType.ANGELS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AngelQueen)
				add_army_unit(ArmyUnit.UnitType.AngelQueen, new_panel)
			PlayerArmy.ArmyType.ALIENS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AlienQueen)
				add_army_unit(ArmyUnit.UnitType.AlienQueen, new_panel)
			PlayerArmy.ArmyType.HUMANS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.HumanQueen)
				add_army_unit(ArmyUnit.UnitType.HumanQueen, new_panel)
	for p in range(PlayerArmy.rooks):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.DemonRook)
				add_army_unit(ArmyUnit.UnitType.DemonRook, new_panel)
			PlayerArmy.ArmyType.ANGELS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AngelRook)
				add_army_unit(ArmyUnit.UnitType.AngelRook, new_panel)
			PlayerArmy.ArmyType.ALIENS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AlienRook)
				add_army_unit(ArmyUnit.UnitType.AlienRook, new_panel)
			PlayerArmy.ArmyType.HUMANS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.HumanRook)
				add_army_unit(ArmyUnit.UnitType.HumanRook, new_panel)
	for p in range(PlayerArmy.bishops):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.DemonBishop)
				add_army_unit(ArmyUnit.UnitType.DemonBishop, new_panel)
			PlayerArmy.ArmyType.ANGELS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AngelBishop)
				add_army_unit(ArmyUnit.UnitType.AngelBishop, new_panel)
			PlayerArmy.ArmyType.ALIENS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AlienBishop)
				add_army_unit(ArmyUnit.UnitType.AlienBishop, new_panel)
			PlayerArmy.ArmyType.HUMANS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.HumanBishop)
				add_army_unit(ArmyUnit.UnitType.HumanBishop, new_panel)
	for p in range(PlayerArmy.knights):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.DemonKnight)
				add_army_unit(ArmyUnit.UnitType.DemonKnight, new_panel)
			PlayerArmy.ArmyType.ANGELS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AngelKnight)
				add_army_unit(ArmyUnit.UnitType.AngelKnight, new_panel)
			PlayerArmy.ArmyType.ALIENS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AlienKnight)
				add_army_unit(ArmyUnit.UnitType.AlienKnight, new_panel)
			PlayerArmy.ArmyType.HUMANS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.HumanKnight)
				add_army_unit(ArmyUnit.UnitType.HumanKnight, new_panel)
	for p in range(PlayerArmy.pawns):
		match(PlayerArmy.army_type):
			PlayerArmy.ArmyType.DEMONS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.DemonPawn)
				add_army_unit(ArmyUnit.UnitType.DemonPawn, new_panel)
			PlayerArmy.ArmyType.ANGELS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AngelPawn)
				add_army_unit(ArmyUnit.UnitType.AngelPawn, new_panel)
			PlayerArmy.ArmyType.ALIENS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.AlienPawn)
				add_army_unit(ArmyUnit.UnitType.AlienPawn, new_panel)
			PlayerArmy.ArmyType.HUMANS:
				var new_panel = create_unit_panel(ArmyUnit.UnitType.HumanPawn)
				add_army_unit(ArmyUnit.UnitType.HumanPawn, new_panel)

func add_army_unit(_unit_type: ArmyUnit.UnitType, _unit_panel: UnitPanel):
	var new_unit = unit_instance.instantiate()
	add_child(new_unit)
	new_unit.unit_type = _unit_type
	new_unit.initialize(_unit_panel)
	PlayerArmy.army.append(new_unit)

func is_in_deployment_zone(tile_coord: Vector2i, unit_size: int, is_player: bool = true) -> bool:
	# Check if the unit (considering its size) fits within the deployment zone
	var unit_bottom_row = tile_coord.x + unit_size - 1

	if is_player:
		# Player deployment zone is the last 'deployment_rows' rows (bottom of the board)
		var min_deployment_row = board.height - deployment_rows
		return tile_coord.x >= min_deployment_row and unit_bottom_row < board.height
	else:
		# Opponent deployment zone is the first 'deployment_rows' rows (top of the board)
		var max_deployment_row = deployment_rows - 1
		return tile_coord.x >= 0 and unit_bottom_row <= max_deployment_row

func deploy_unit():
	var real_position = Vector3(board.active_tile.tile_id.y * board.unit_dimension, 0.1, board.active_tile.tile_id.x * board.unit_dimension)
	active_unit.set_3d_position(real_position)
	active_unit.board_position = board.active_tile.tile_id
	active_unit.visible = true
	board.occupy_tiles(active_unit)

func handle_tile_input(tile_coord):
	match(match_state):
		MatchState.DEPLOY:
			if not is_in_deployment_zone(tile_coord, active_unit.unit_size):
				admiral.speech_text.text = "You must deploy in your deployment zone!"
				return
			if(board.is_space_occupied(tile_coord, active_unit.unit_size)):
				admiral.speech_text.text = "Are you crazy?! We can't do that!"
				return
			board.select_tiles(tile_coord, active_unit.unit_size)
			admiral.speech_text.text = "Are you sure?"
			confirm_button.visible = true
		MatchState.BATTLE:
			# If we have a friendly unit selected in MOVE stance
			if active_unit != null and active_unit.player_unit and active_unit.stance == ArmyUnit.Stance.MOVE:
				# Check if clicking on a potential move tile
				var is_valid_move = false
				for tile in board.potential_move_tiles:
					if tile.tile_id == tile_coord:
						is_valid_move = true
						break

				if is_valid_move:
					# Calculate and highlight path
					var path = board.calculate_path(active_unit.board_position, tile_coord, active_unit)
					if path.size() > 0:
						board.highlight_movement_path(path)
						pending_move_order["unit"] = active_unit
						pending_move_order["target"] = tile_coord
						pending_move_order["path"] = path
						confirm_button.visible = true
						admiral.speech_text.text = "Confirm move order?"
					return

			# Check if clicking on a unit
			if board.is_space_occupied(tile_coord, 1):
				var clicked_unit = board.get_tile(tile_coord).occupying_unit()

				# If clicking on a friendly unit
				if clicked_unit != null and clicked_unit.player_unit:
					# If there was a previous active unit, reset it
					if active_unit != null and active_unit != clicked_unit:
						active_unit.stance = ArmyUnit.Stance.DEFEND
						board.clear_potential_moves()
						board.clear_movement_path()
						pending_move_order.clear()
						confirm_button.visible = false

					# Select the new unit
					active_unit = clicked_unit
					active_unit.stance = ArmyUnit.Stance.MOVE
					board.select_tiles(active_unit.board_position, active_unit.unit_size)
					show_player_unit_panel(active_unit)

					# Highlight potential moves
					board.highlight_potential_moves(active_unit)
					admiral.speech_text.text = "Unit selected - Move stance"

				# If clicking on enemy unit when no friendly unit is selected
				elif clicked_unit != null and not clicked_unit.player_unit:
					active_unit = clicked_unit
					board.select_tiles(active_unit.board_position, active_unit.unit_size)
					show_opponent_unit_panel(active_unit)
		_:
			pass

func set_next_unit_for_deployment():
	if(deploy_index > 0):
		PlayerArmy.army[deploy_index-1].linked_panel.visible = false
	active_unit = PlayerArmy.army[deploy_index]
	show_player_unit_panel(active_unit)
	active_unit.linked_panel.visible = true
	deploy_index += 1

func show_player_unit_panel(_unit: ArmyUnit):
	# Hide all player unit panels
	for u in PlayerArmy.army:
		u.linked_panel.visible = false
	# Hide all opponent unit panels
	for u in opponent_army:
		if u.linked_panel:
			u.linked_panel.visible = false
	# Show the selected player unit panel
	_unit.linked_panel.visible = true
	if(match_state == MatchState.BATTLE):
		_unit.linked_panel.show_order_buttons(true)

func show_opponent_unit_panel(_unit: ArmyUnit):
	# Hide all player unit panels
	for u in PlayerArmy.army:
		u.linked_panel.visible = false
	# Hide all opponent unit panels
	for u in opponent_army:
		if u.linked_panel:
			u.linked_panel.visible = false
	# Show the selected opponent unit panel
	if _unit.linked_panel:
		_unit.linked_panel.visible = true
		_unit.linked_panel.show_order_buttons(false)

func confirm_action():
	match(match_state):
		MatchState.DEPLOY:
			if current_deploy_turn == DeployTurn.PLAYER:
				# Store player's deployment (hidden from opponent)
				pending_deployment["unit"] = active_unit
				pending_deployment["position"] = board.active_tile.tile_id
				admiral.speech_text.text = "Waiting for opponent..."
				confirm_button.visible = false
				board.deselect_tiles()

				# Switch to opponent turn
				current_deploy_turn = DeployTurn.OPPONENT
				process_opponent_deployment()
		MatchState.BATTLE:
			if pending_move_order.has("unit"):
				# Store the move order instead of executing immediately
				confirmed_orders.append(pending_move_order.duplicate())

				# Increment order count
				orders_issued += 1

				# Clear UI
				board.clear_movement_path()
				board.clear_potential_moves()
				board.deselect_tiles()
				confirm_button.visible = false
				active_unit.stance = ArmyUnit.Stance.DEFEND
				active_unit = null
				pending_move_order.clear()

				# Check if max orders reached
				if orders_issued >= max_orders_per_turn:
					end_turn()
				else:
					admiral.speech_text.text = "Order confirmed! " + str(max_orders_per_turn - orders_issued) + " orders remaining."
		_:
			pass

func reveal_and_deploy_units():
	# Deploy player unit
	if pending_deployment.has("unit"):
		var player_unit = pending_deployment["unit"]
		var player_pos = pending_deployment["position"]
		var real_position = Vector3(player_pos.y * board.unit_dimension, 0.1, player_pos.x * board.unit_dimension)
		player_unit.set_3d_position(real_position)
		player_unit.board_position = player_pos
		player_unit.visible = true
		board.occupy_tiles(player_unit)

	# Deploy opponent unit
	if pending_deployment.has("opponent_unit"):
		var opp_unit = pending_deployment["opponent_unit"]
		var opp_pos = pending_deployment["opponent_position"]
		var real_position = Vector3(opp_pos.y * board.unit_dimension, 0.1, opp_pos.x * board.unit_dimension)
		opp_unit.set_3d_position(real_position)
		opp_unit.board_position = opp_pos
		opp_unit.visible = true
		board.occupy_tiles(opp_unit)

	pending_deployment.clear()

	# Check if deployment is complete
	var player_done = deploy_index >= PlayerArmy.army.size()
	var opponent_done = opponent_deploy_index >= opponent_army.size()

	if player_done and opponent_done:
		admiral.speech_text.text = "Prepare to fight!"
		match_state = MatchState.BATTLE
		active_unit = null
	else:
		# Continue deployment
		if not player_done:
			set_next_unit_for_deployment()
		if not opponent_done:
			set_next_opponent_unit_for_deployment()
		current_deploy_turn = DeployTurn.PLAYER

		# If player is done but opponent isn't, skip to opponent
		if player_done and not opponent_done:
			admiral.speech_text.text = "Opponent is still deploying..."
			process_opponent_deployment()

func draft_opponent_army():
	# Calculate player army supply cost
	var player_supply_cost = 0
	for unit in PlayerArmy.army:
		player_supply_cost += get_unit_supply_cost(unit.unit_type)

	# Choose random opponent race (different from player)
	var available_races = [PlayerArmy.ArmyType.DEMONS, PlayerArmy.ArmyType.ANGELS,
						   PlayerArmy.ArmyType.ALIENS, PlayerArmy.ArmyType.HUMANS]
	available_races.erase(PlayerArmy.army_type)
	opponent_army_type = available_races[randi() % available_races.size()]

	# Start with required units: 1 queen and 2 rooks
	var current_supply = 0
	var queen_supply = UnitInfo.queen_supply
	var rook_supply = UnitInfo.rook_supply

	current_supply = queen_supply + (rook_supply * 2)

	# Remaining supply to fill with random units
	var remaining_supply = player_supply_cost - current_supply

	# Unit types and their supply costs (excluding queen since we already have 1)
	var unit_choices = []
	var pawn_supply = UnitInfo.pawn_supply
	var knight_supply = UnitInfo.knight_supply
	var bishop_supply = UnitInfo.bishop_supply
	# set up remaining unit types to be chosen from
	var possible_units = []
	possible_units.append("pawn")
	possible_units.append("knight")
	possible_units.append("bishop")
	# Fill remaining supply with random units
	while remaining_supply > 0:
		if possible_units.size() == 0:
			break  # Can't fit any more units
		var chosen = possible_units[randi() % possible_units.size()]
		unit_choices.append(chosen)
		match chosen:
			"pawn":
				remaining_supply -= pawn_supply
			"knight":
				remaining_supply -= knight_supply
			"bishop":
				remaining_supply -= bishop_supply

	# Build the opponent army
	# Add queen
	var queen_type = get_unit_type_for_race(opponent_army_type, "queen")
	add_opponent_unit(queen_type)

	# Add 2 rooks
	var rook_type = get_unit_type_for_race(opponent_army_type, "rook")
	add_opponent_unit(rook_type)
	add_opponent_unit(rook_type)

	# Add other units
	for unit_choice in unit_choices:
		var unit_type = get_unit_type_for_race(opponent_army_type, unit_choice)
		add_opponent_unit(unit_type)
	
	set_next_opponent_unit_for_deployment()

func get_unit_type_for_race(race: PlayerArmy.ArmyType, unit_class: String) -> ArmyUnit.UnitType:
	match race:
		PlayerArmy.ArmyType.DEMONS:
			match unit_class:
				"pawn": return ArmyUnit.UnitType.DemonPawn
				"knight": return ArmyUnit.UnitType.DemonKnight
				"bishop": return ArmyUnit.UnitType.DemonBishop
				"rook": return ArmyUnit.UnitType.DemonRook
				"queen": return ArmyUnit.UnitType.DemonQueen
		PlayerArmy.ArmyType.ANGELS:
			match unit_class:
				"pawn": return ArmyUnit.UnitType.AngelPawn
				"knight": return ArmyUnit.UnitType.AngelKnight
				"bishop": return ArmyUnit.UnitType.AngelBishop
				"rook": return ArmyUnit.UnitType.AngelRook
				"queen": return ArmyUnit.UnitType.AngelQueen
		PlayerArmy.ArmyType.ALIENS:
			match unit_class:
				"pawn": return ArmyUnit.UnitType.AlienPawn
				"knight": return ArmyUnit.UnitType.AlienKnight
				"bishop": return ArmyUnit.UnitType.AlienBishop
				"rook": return ArmyUnit.UnitType.AlienRook
				"queen": return ArmyUnit.UnitType.AlienQueen
		PlayerArmy.ArmyType.HUMANS:
			match unit_class:
				"pawn": return ArmyUnit.UnitType.HumanPawn
				"knight": return ArmyUnit.UnitType.HumanKnight
				"bishop": return ArmyUnit.UnitType.HumanBishop
				"rook": return ArmyUnit.UnitType.HumanRook
				"queen": return ArmyUnit.UnitType.HumanQueen
	return ArmyUnit.UnitType.DemonPawn  # Fallback

func get_unit_supply_cost(unit_type: ArmyUnit.UnitType) -> int:
	match unit_type:
		ArmyUnit.UnitType.DemonPawn, ArmyUnit.UnitType.AngelPawn, ArmyUnit.UnitType.AlienPawn, ArmyUnit.UnitType.HumanPawn:
			return UnitInfo.pawn_supply
		ArmyUnit.UnitType.DemonKnight, ArmyUnit.UnitType.AngelKnight, ArmyUnit.UnitType.AlienKnight, ArmyUnit.UnitType.HumanKnight:
			return UnitInfo.knight_supply
		ArmyUnit.UnitType.DemonBishop, ArmyUnit.UnitType.AngelBishop, ArmyUnit.UnitType.AlienBishop, ArmyUnit.UnitType.HumanBishop:
			return UnitInfo.bishop_supply
		ArmyUnit.UnitType.DemonRook, ArmyUnit.UnitType.AngelRook, ArmyUnit.UnitType.AlienRook, ArmyUnit.UnitType.HumanRook:
			return UnitInfo.rook_supply
		ArmyUnit.UnitType.DemonQueen, ArmyUnit.UnitType.AngelQueen, ArmyUnit.UnitType.AlienQueen, ArmyUnit.UnitType.HumanQueen:
			return UnitInfo.queen_supply
	return 0

func add_opponent_unit(unit_type: ArmyUnit.UnitType):
	var new_unit = unit_instance.instantiate()
	add_child(new_unit)
	new_unit.unit_type = unit_type

	# Create panel for opponent unit
	var new_panel = create_opponent_unit_panel(unit_type)
	new_unit.initialize(new_panel)

	new_unit.player_unit = false
	new_unit.visible = false  # Hidden until deployed
	opponent_army.append(new_unit)

func create_opponent_unit_panel(unit_type: ArmyUnit.UnitType):
	var new_panel = player_unit_panel.duplicate()
	unit_panel_container.add_child(new_panel)
	new_panel.initialize(unit_type)
	new_panel.visible = false  # Hidden by default
	return new_panel

func sort_armies_by_supply_cost():
	# Sort player army by supply cost (highest to lowest)
	PlayerArmy.army.sort_custom(func(a, b): return get_unit_supply_cost(a.unit_type) > get_unit_supply_cost(b.unit_type))

	# Sort opponent army by supply cost (highest to lowest)
	opponent_army.sort_custom(func(a, b): return get_unit_supply_cost(a.unit_type) > get_unit_supply_cost(b.unit_type))

func set_next_opponent_unit_for_deployment():
	if opponent_deploy_index < opponent_army.size():
		opponent_active_unit = opponent_army[opponent_deploy_index]
		opponent_deploy_index += 1

func process_opponent_deployment():
	# CPU AI for deployment
	if opponent_deploy_index >= opponent_army.size():
		# Opponent is done deploying
		reveal_and_deploy_units()
		return

	# Get opponent's deployment zone (top rows)
	var min_row = 0
	var max_row = deployment_rows - 1

	# Get current unit's supply cost
	var current_supply = get_unit_supply_cost(opponent_active_unit.unit_type)

	# Prioritize front line (closer to player) for lower supply units
	var preferred_row_offset = 0
	if current_supply <= UnitInfo.pawn_supply:
		preferred_row_offset = deployment_rows - 1  # Front line (bottom of opponent zone)
	elif current_supply <= UnitInfo.knight_supply:
		preferred_row_offset = int(deployment_rows * 0.66)
	elif current_supply <= UnitInfo.bishop_supply:
		preferred_row_offset = int(deployment_rows * 0.33)
	else:
		preferred_row_offset = 0  # Back line for high value units

	# Try to find a valid position
	var attempts = 0
	var max_attempts = 100
	var deployed = false

	while not deployed and attempts < max_attempts:
		# Try preferred row first, then branch out
		var row_variance = int(attempts / 10)
		var try_row = preferred_row_offset + (randi() % (row_variance * 2 + 1) - row_variance)
		try_row = clampi(try_row, min_row, max_row)

		var try_col = randi() % board.width
		var try_pos = Vector2i(try_row, try_col)

		# Check if position is valid (in opponent zone and not occupied)
		if is_in_deployment_zone(try_pos, opponent_active_unit.unit_size, false) and not board.is_space_occupied(try_pos, opponent_active_unit.unit_size):
			# Valid position found
			pending_deployment["opponent_unit"] = opponent_active_unit
			pending_deployment["opponent_position"] = try_pos
			deployed = true

			# Small delay to simulate thinking, then reveal both deployments
			await get_tree().create_timer(0.5).timeout
			reveal_and_deploy_units()

		attempts += 1

	if not deployed:
		print("Warning: Could not find valid deployment position for opponent unit!")

func set_attack_stance():
	if active_unit != null and active_unit.player_unit:
		active_unit.stance = ArmyUnit.Stance.ATTACK
		board.clear_potential_moves()
		admiral.speech_text.text = "Attack stance set!"

func set_move_stance():
	if active_unit != null and active_unit.player_unit:
		active_unit.stance = ArmyUnit.Stance.MOVE
		board.highlight_potential_moves(active_unit)
		admiral.speech_text.text = "Move stance set!"

func execute_move_order(move_order: Dictionary):
	var unit: ArmyUnit = move_order["unit"]
	var path: Array = move_order["path"]

	# Free current tiles at the start
	board.free_tiles(unit.board_position, unit.unit_size)

	# Move step by step through the path
	for i in range(path.size()):
		var step_position: Vector2i = path[i]

		# Update unit position
		unit.board_position = step_position
		var real_position = Vector3(step_position.y * board.unit_dimension, 0.1, step_position.x * board.unit_dimension)
		unit.set_3d_position(real_position)

		# Check for enemy encounters during movement
		if unit.flying:
			# Flying units stop if they encounter enemy flying units
			if board.is_space_occupied_by_enemy_flying(step_position, unit.unit_size, unit.player_unit):
				# Stop movement here - combat will be implemented later
				break
		# TODO: Add grounded unit combat checks when needed

		# Wait for the step delay (except on the last step)
		if i < path.size() - 1:
			await get_tree().create_timer(move_step_delay).timeout

	# Occupy tiles at final position
	board.occupy_tiles(unit)

func end_turn():
	# Clear any pending orders and UI
	board.clear_movement_path()
	board.clear_potential_moves()
	board.deselect_tiles()
	confirm_button.visible = false
	if active_unit != null:
		active_unit.stance = ArmyUnit.Stance.DEFEND
	active_unit = null
	pending_move_order.clear()

	# Execute all confirmed orders
	admiral.speech_text.text = "Executing orders..."
	for order in confirmed_orders:
		await execute_move_order(order)

	# Clear confirmed orders
	confirmed_orders.clear()

	# Reset order count
	orders_issued = 0

	# Process CPU opponent's turn
	admiral.speech_text.text = "Opponent's turn..."
	await process_opponent_turn()

	# Start new turn
	admiral.speech_text.text = "Your turn! " + str(max_orders_per_turn) + " orders available."

func process_opponent_turn():
	# Simple random move orders for CPU
	var available_units = opponent_army.duplicate()
	var opponent_orders: Array[Dictionary] = []

	# Generate opponent orders
	while opponent_orders.size() < max_orders_per_turn and available_units.size() > 0:
		# Pick random unit
		var random_index = randi() % available_units.size()
		var unit = available_units[random_index]
		available_units.remove_at(random_index)

		# Calculate reachable tiles
		var reachable = board.calculate_reachable_tiles(unit)

		if reachable.size() > 0:
			# Pick random destination
			var random_dest = reachable[randi() % reachable.size()]

			# Calculate path
			var path = board.calculate_path(unit.board_position, random_dest, unit)

			# Store the order
			if path.size() > 0:
				var order = {
					"unit": unit,
					"target": random_dest,
					"path": path
				}
				opponent_orders.append(order)

	# Execute all opponent orders
	for order in opponent_orders:
		await execute_move_order(order)
