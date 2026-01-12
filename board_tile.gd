extends MeshInstance3D
class_name BoardTile

var board: GameBoard

@export var dark: bool

@export var tile_id: Vector2i
var occupied: bool = false
var occupied_by: ArmyUnit = null

@export var highlight_color: Color = Color.PURPLE
@export var occupied_by_ally_color: Color = Color.GREEN
@export var occupied_by_enemy_color: Color = Color.RED
@export var default_color: Color = Color.GRAY

func _ready():
	board = get_parent() as GameBoard

func update_shade():
	if(!dark):
		return
	var mat = get_active_material(0).duplicate()
	var new_color = mat.albedo_color
	new_color = new_color.darkened(0.5)
	mat.albedo_color = new_color
	set_surface_override_material(0, mat)

func highlight():
	var mat = get_active_material(0).duplicate()
	mat.albedo_color = highlight_color
	set_surface_override_material(0, mat)
	update_shade()

func deselect_tile():
	var mat = get_active_material(0).duplicate()
	mat.albedo_color = default_color
	set_surface_override_material(0, mat)
	update_shade()


func _on_static_body_3d_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		GlobalSignals.tile_clicked.emit(tile_id)

func occupying_unit() -> ArmyUnit :
	return occupied_by

func occupy_tile(_unit: ArmyUnit):
	occupied_by = _unit
	occupied = true

func free_tile():
	occupied_by = null
	occupied = false
