extends PanelContainer

var unit_type: ArmyUnit.UnitType
@export var unit_portrait: TextureRect
@export var unit_name: Label
@export var supply_cost: Label
@export var unit_size: Label

@export var deploy_color: Color = Color.GREEN
@export var deployed_color: Color = Color.SANDY_BROWN
@export var standby_color: Color = Color.WHITE

func deployed():
	self_modulate = deployed_color

func prepare_to_deploy():
	self_modulate = deploy_color

func initialize(_unit_type: ArmyUnit.UnitType):
	unit_type = _unit_type
	match(unit_type):
		ArmyUnit.UnitType.DemonPawn:
			unit_portrait.texture = UnitInfo.demon_pawn_portrait
			unit_name.text = UnitInfo.demon_pawn_name
			supply_cost.text = str(UnitInfo.demon_pawn_supply)
			unit_size.text = str(UnitInfo.demon_pawn_size)
		ArmyUnit.UnitType.DemonKnight:
			unit_portrait.texture = UnitInfo.demon_knight_portrait
			unit_name.text = UnitInfo.demon_knight_name
			supply_cost.text = str(UnitInfo.demon_knight_supply)
			unit_size.text = str(UnitInfo.demon_knight_size)
		ArmyUnit.UnitType.DemonBishop:
			unit_portrait.texture = UnitInfo.demon_bishop_portrait
			unit_name.text = UnitInfo.demon_bishop_name
			supply_cost.text = str(UnitInfo.demon_bishop_supply)
			unit_size.text = str(UnitInfo.demon_bishop_size)
		ArmyUnit.UnitType.DemonRook:
			unit_portrait.texture = UnitInfo.demon_rook_portrait
			unit_name.text = UnitInfo.demon_rook_name
			supply_cost.text = str(UnitInfo.demon_rook_supply)
			unit_size.text = str(UnitInfo.demon_rook_size)
		ArmyUnit.UnitType.DemonQueen:
			unit_portrait.texture = UnitInfo.demon_queen_portrait
			unit_name.text = UnitInfo.demon_queen_name
			supply_cost.text = str(UnitInfo.demon_queen_supply)
			unit_size.text = str(UnitInfo.demon_queen_size)
		ArmyUnit.UnitType.AngelPawn:
			unit_portrait.texture = UnitInfo.angel_pawn_portrait
			unit_name.text = UnitInfo.angel_pawn_name
			supply_cost.text = str(UnitInfo.angel_pawn_supply)
			unit_size.text = str(UnitInfo.angel_pawn_size)
		ArmyUnit.UnitType.AngelKnight:
			unit_portrait.texture = UnitInfo.angel_knight_portrait
			unit_name.text = UnitInfo.angel_knight_name
			supply_cost.text = str(UnitInfo.angel_knight_supply)
			unit_size.text = str(UnitInfo.angel_knight_size)
		ArmyUnit.UnitType.AngelBishop:
			unit_portrait.texture = UnitInfo.angel_bishop_portrait
			unit_name.text = UnitInfo.angel_bishop_name
			supply_cost.text = str(UnitInfo.angel_bishop_supply)
			unit_size.text = str(UnitInfo.angel_bishop_size)
		ArmyUnit.UnitType.AngelRook:
			unit_portrait.texture = UnitInfo.angel_rook_portrait
			unit_name.text = UnitInfo.angel_rook_name
			supply_cost.text = str(UnitInfo.angel_rook_supply)
			unit_size.text = str(UnitInfo.angel_rook_size)
		ArmyUnit.UnitType.AngelQueen:
			unit_portrait.texture = UnitInfo.angel_queen_portrait
			unit_name.text = UnitInfo.angel_queen_name
			supply_cost.text = str(UnitInfo.angel_queen_supply)
			unit_size.text = str(UnitInfo.angel_queen_size)
		ArmyUnit.UnitType.AlienPawn:
			unit_portrait.texture = UnitInfo.alien_pawn_portrait
			unit_name.text = UnitInfo.alien_pawn_name
			supply_cost.text = str(UnitInfo.alien_pawn_supply)
			unit_size.text = str(UnitInfo.alien_pawn_size)
		ArmyUnit.UnitType.AlienKnight:
			unit_portrait.texture = UnitInfo.alien_knight_portrait
			unit_name.text = UnitInfo.alien_knight_name
			supply_cost.text = str(UnitInfo.alien_knight_supply)
			unit_size.text = str(UnitInfo.alien_knight_size)
		ArmyUnit.UnitType.AlienBishop:
			unit_portrait.texture = UnitInfo.alien_bishop_portrait
			unit_name.text = UnitInfo.alien_bishop_name
			supply_cost.text = str(UnitInfo.alien_bishop_supply)
			unit_size.text = str(UnitInfo.alien_bishop_size)
		ArmyUnit.UnitType.AlienRook:
			unit_portrait.texture = UnitInfo.alien_rook_portrait
			unit_name.text = UnitInfo.alien_rook_name
			supply_cost.text = str(UnitInfo.alien_rook_supply)
			unit_size.text = str(UnitInfo.alien_rook_size)
		ArmyUnit.UnitType.AlienQueen:
			unit_portrait.texture = UnitInfo.alien_queen_portrait
			unit_name.text = UnitInfo.alien_queen_name
			supply_cost.text = str(UnitInfo.alien_queen_supply)
			unit_size.text = str(UnitInfo.alien_queen_size)
		ArmyUnit.UnitType.HumanPawn:
			unit_portrait.texture = UnitInfo.human_pawn_portrait
			unit_name.text = UnitInfo.human_pawn_name
			supply_cost.text = str(UnitInfo.human_pawn_supply)
			unit_size.text = str(UnitInfo.human_pawn_size)
		ArmyUnit.UnitType.HumanKnight:
			unit_portrait.texture = UnitInfo.human_knight_portrait
			unit_name.text = UnitInfo.human_knight_name
			supply_cost.text = str(UnitInfo.human_knight_supply)
			unit_size.text = str(UnitInfo.human_knight_size)
		ArmyUnit.UnitType.HumanBishop:
			unit_portrait.texture = UnitInfo.human_bishop_portrait
			unit_name.text = UnitInfo.human_bishop_name
			supply_cost.text = str(UnitInfo.human_bishop_supply)
			unit_size.text = str(UnitInfo.human_bishop_size)
		ArmyUnit.UnitType.HumanRook:
			unit_portrait.texture = UnitInfo.human_rook_portrait
			unit_name.text = UnitInfo.human_rook_name
			supply_cost.text = str(UnitInfo.human_rook_supply)
			unit_size.text = str(UnitInfo.human_rook_size)
		ArmyUnit.UnitType.HumanQueen:
			unit_portrait.texture = UnitInfo.human_queen_portrait
			unit_name.text = UnitInfo.human_queen_name
			supply_cost.text = str(UnitInfo.human_queen_supply)
			unit_size.text = str(UnitInfo.human_queen_size)