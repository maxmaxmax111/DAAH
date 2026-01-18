extends PanelContainer
class_name UnitPanel

var unit_type: ArmyUnit.UnitType
@export var unit_portrait: TextureRect
@export var unit_name: Label
@export var supply_cost: Label
@export var unit_size: Label
@export var move_speed: Label
@export var flying_status: Label
@export var unit_blurb: Label

@export var order_buttons: Control

func initialize(_unit_type: ArmyUnit.UnitType):
	unit_type = _unit_type
	match(unit_type):
		ArmyUnit.UnitType.DemonPawn:
			unit_portrait.texture = UnitInfo.demon_pawn_portrait
			unit_name.text = UnitInfo.demon_pawn_name
			supply_cost.text = str(UnitInfo.demon_pawn_supply)
			unit_size.text = str(UnitInfo.demon_pawn_size)
			move_speed.text = str(UnitInfo.demon_pawn_move_speed)
			flying_status.text = "Flying" if UnitInfo.demon_pawn_flying else "Grounded"
			unit_blurb.text = UnitInfo.demon_pawn_blurb
		ArmyUnit.UnitType.DemonKnight:
			unit_portrait.texture = UnitInfo.demon_knight_portrait
			unit_name.text = UnitInfo.demon_knight_name
			supply_cost.text = str(UnitInfo.demon_knight_supply)
			unit_size.text = str(UnitInfo.demon_knight_size)
			move_speed.text = str(UnitInfo.demon_knight_move_speed)
			flying_status.text = "Flying" if UnitInfo.demon_knight_flying else "Grounded"
			unit_blurb.text = UnitInfo.demon_knight_blurb
		ArmyUnit.UnitType.DemonBishop:
			unit_portrait.texture = UnitInfo.demon_bishop_portrait
			unit_name.text = UnitInfo.demon_bishop_name
			supply_cost.text = str(UnitInfo.demon_bishop_supply)
			unit_size.text = str(UnitInfo.demon_bishop_size)
			move_speed.text = str(UnitInfo.demon_bishop_move_speed)
			flying_status.text = "Flying" if UnitInfo.demon_bishop_flying else "Grounded"
			unit_blurb.text = UnitInfo.demon_bishop_blurb
		ArmyUnit.UnitType.DemonRook:
			unit_portrait.texture = UnitInfo.demon_rook_portrait
			unit_name.text = UnitInfo.demon_rook_name
			supply_cost.text = str(UnitInfo.demon_rook_supply)
			unit_size.text = str(UnitInfo.demon_rook_size)
			move_speed.text = str(UnitInfo.demon_rook_move_speed)
			flying_status.text = "Flying" if UnitInfo.demon_rook_flying else "Grounded"
			unit_blurb.text = UnitInfo.demon_rook_blurb
		ArmyUnit.UnitType.DemonQueen:
			unit_portrait.texture = UnitInfo.demon_queen_portrait
			unit_name.text = UnitInfo.demon_queen_name
			supply_cost.text = str(UnitInfo.demon_queen_supply)
			unit_size.text = str(UnitInfo.demon_queen_size)
			move_speed.text = str(UnitInfo.demon_queen_move_speed)
			flying_status.text = "Flying" if UnitInfo.demon_queen_flying else "Grounded"
			unit_blurb.text = UnitInfo.demon_queen_blurb
		ArmyUnit.UnitType.AngelPawn:
			unit_portrait.texture = UnitInfo.angel_pawn_portrait
			unit_name.text = UnitInfo.angel_pawn_name
			supply_cost.text = str(UnitInfo.angel_pawn_supply)
			unit_size.text = str(UnitInfo.angel_pawn_size)
			move_speed.text = str(UnitInfo.angel_pawn_move_speed)
			flying_status.text = "Flying" if UnitInfo.angel_pawn_flying else "Grounded"
			unit_blurb.text = UnitInfo.angel_pawn_blurb
		ArmyUnit.UnitType.AngelKnight:
			unit_portrait.texture = UnitInfo.angel_knight_portrait
			unit_name.text = UnitInfo.angel_knight_name
			supply_cost.text = str(UnitInfo.angel_knight_supply)
			unit_size.text = str(UnitInfo.angel_knight_size)
			move_speed.text = str(UnitInfo.angel_knight_move_speed)
			flying_status.text = "Flying" if UnitInfo.angel_knight_flying else "Grounded"
			unit_blurb.text = UnitInfo.angel_knight_blurb
		ArmyUnit.UnitType.AngelBishop:
			unit_portrait.texture = UnitInfo.angel_bishop_portrait
			unit_name.text = UnitInfo.angel_bishop_name
			supply_cost.text = str(UnitInfo.angel_bishop_supply)
			unit_size.text = str(UnitInfo.angel_bishop_size)
			move_speed.text = str(UnitInfo.angel_bishop_move_speed)
			flying_status.text = "Flying" if UnitInfo.angel_bishop_flying else "Grounded"
			unit_blurb.text = UnitInfo.angel_bishop_blurb
		ArmyUnit.UnitType.AngelRook:
			unit_portrait.texture = UnitInfo.angel_rook_portrait
			unit_name.text = UnitInfo.angel_rook_name
			supply_cost.text = str(UnitInfo.angel_rook_supply)
			unit_size.text = str(UnitInfo.angel_rook_size)
			move_speed.text = str(UnitInfo.angel_rook_move_speed)
			flying_status.text = "Flying" if UnitInfo.angel_rook_flying else "Grounded"
			unit_blurb.text = UnitInfo.angel_rook_blurb
		ArmyUnit.UnitType.AngelQueen:
			unit_portrait.texture = UnitInfo.angel_queen_portrait
			unit_name.text = UnitInfo.angel_queen_name
			supply_cost.text = str(UnitInfo.angel_queen_supply)
			unit_size.text = str(UnitInfo.angel_queen_size)
			move_speed.text = str(UnitInfo.angel_queen_move_speed)
			flying_status.text = "Flying" if UnitInfo.angel_queen_flying else "Grounded"
			unit_blurb.text = UnitInfo.angel_queen_blurb
		ArmyUnit.UnitType.AlienPawn:
			unit_portrait.texture = UnitInfo.alien_pawn_portrait
			unit_name.text = UnitInfo.alien_pawn_name
			supply_cost.text = str(UnitInfo.alien_pawn_supply)
			unit_size.text = str(UnitInfo.alien_pawn_size)
			move_speed.text = str(UnitInfo.alien_pawn_move_speed)
			flying_status.text = "Flying" if UnitInfo.alien_pawn_flying else "Grounded"
			unit_blurb.text = UnitInfo.alien_pawn_blurb
		ArmyUnit.UnitType.AlienKnight:
			unit_portrait.texture = UnitInfo.alien_knight_portrait
			unit_name.text = UnitInfo.alien_knight_name
			supply_cost.text = str(UnitInfo.alien_knight_supply)
			unit_size.text = str(UnitInfo.alien_knight_size)
			move_speed.text = str(UnitInfo.alien_knight_move_speed)
			flying_status.text = "Flying" if UnitInfo.alien_knight_flying else "Grounded"
			unit_blurb.text = UnitInfo.alien_knight_blurb
		ArmyUnit.UnitType.AlienBishop:
			unit_portrait.texture = UnitInfo.alien_bishop_portrait
			unit_name.text = UnitInfo.alien_bishop_name
			supply_cost.text = str(UnitInfo.alien_bishop_supply)
			unit_size.text = str(UnitInfo.alien_bishop_size)
			move_speed.text = str(UnitInfo.alien_bishop_move_speed)
			flying_status.text = "Flying" if UnitInfo.alien_bishop_flying else "Grounded"
			unit_blurb.text = UnitInfo.alien_bishop_blurb
		ArmyUnit.UnitType.AlienRook:
			unit_portrait.texture = UnitInfo.alien_rook_portrait
			unit_name.text = UnitInfo.alien_rook_name
			supply_cost.text = str(UnitInfo.alien_rook_supply)
			unit_size.text = str(UnitInfo.alien_rook_size)
			move_speed.text = str(UnitInfo.alien_rook_move_speed)
			flying_status.text = "Flying" if UnitInfo.alien_rook_flying else "Grounded"
			unit_blurb.text = UnitInfo.alien_rook_blurb
		ArmyUnit.UnitType.AlienQueen:
			unit_portrait.texture = UnitInfo.alien_queen_portrait
			unit_name.text = UnitInfo.alien_queen_name
			supply_cost.text = str(UnitInfo.alien_queen_supply)
			unit_size.text = str(UnitInfo.alien_queen_size)
			move_speed.text = str(UnitInfo.alien_queen_move_speed)
			flying_status.text = "Flying" if UnitInfo.alien_queen_flying else "Grounded"
			unit_blurb.text = UnitInfo.alien_queen_blurb
		ArmyUnit.UnitType.HumanPawn:
			unit_portrait.texture = UnitInfo.human_pawn_portrait
			unit_name.text = UnitInfo.human_pawn_name
			supply_cost.text = str(UnitInfo.human_pawn_supply)
			unit_size.text = str(UnitInfo.human_pawn_size)
			move_speed.text = str(UnitInfo.human_pawn_move_speed)
			flying_status.text = "Flying" if UnitInfo.human_pawn_flying else "Grounded"
			unit_blurb.text = UnitInfo.human_pawn_blurb
		ArmyUnit.UnitType.HumanKnight:
			unit_portrait.texture = UnitInfo.human_knight_portrait
			unit_name.text = UnitInfo.human_knight_name
			supply_cost.text = str(UnitInfo.human_knight_supply)
			unit_size.text = str(UnitInfo.human_knight_size)
			move_speed.text = str(UnitInfo.human_knight_move_speed)
			flying_status.text = "Flying" if UnitInfo.human_knight_flying else "Grounded"
			unit_blurb.text = UnitInfo.human_knight_blurb
		ArmyUnit.UnitType.HumanBishop:
			unit_portrait.texture = UnitInfo.human_bishop_portrait
			unit_name.text = UnitInfo.human_bishop_name
			supply_cost.text = str(UnitInfo.human_bishop_supply)
			unit_size.text = str(UnitInfo.human_bishop_size)
			move_speed.text = str(UnitInfo.human_bishop_move_speed)
			flying_status.text = "Flying" if UnitInfo.human_bishop_flying else "Grounded"
			unit_blurb.text = UnitInfo.human_bishop_blurb
		ArmyUnit.UnitType.HumanRook:
			unit_portrait.texture = UnitInfo.human_rook_portrait
			unit_name.text = UnitInfo.human_rook_name
			supply_cost.text = str(UnitInfo.human_rook_supply)
			unit_size.text = str(UnitInfo.human_rook_size)
			move_speed.text = str(UnitInfo.human_rook_move_speed)
			flying_status.text = "Flying" if UnitInfo.human_rook_flying else "Grounded"
			unit_blurb.text = UnitInfo.human_rook_blurb
		ArmyUnit.UnitType.HumanQueen:
			unit_portrait.texture = UnitInfo.human_queen_portrait
			unit_name.text = UnitInfo.human_queen_name
			supply_cost.text = str(UnitInfo.human_queen_supply)
			unit_size.text = str(UnitInfo.human_queen_size)
			move_speed.text = str(UnitInfo.human_queen_move_speed)
			flying_status.text = "Flying" if UnitInfo.human_queen_flying else "Grounded"
			unit_blurb.text = UnitInfo.human_queen_blurb

func show_order_buttons(make_visible: bool = true):
	print("delete this function!")
