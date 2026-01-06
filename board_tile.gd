extends MeshInstance3D
class_name BoardTile

var board: GameBoard

@export var dark: bool

@export var tile_id: Vector2i
var occupied: bool = false
var occupied_by: ArmyUnit = null

var selected: bool = false

@export var selected_color: Color = Color.PURPLE
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

func select_tile():
	if(selected):
		return
	selected = true
	var mat = get_active_material(0).duplicate()
	mat.albedo_color = selected_color
	set_surface_override_material(0, mat)
	update_shade()

func deselect_tile():
	selected = false
	var mat = get_active_material(0).duplicate()
	mat.albedo_color = default_color
	set_surface_override_material(0, mat)
	update_shade()


func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		select_tile()

func occupying_unit() -> ArmyUnit :
	return occupied_by

func occupy_tile(occupying_unit: ArmyUnit):
	occupied_by = occupying_unit
	occupied = true

func free_tile():
	occupied_by = null
	occupied = false