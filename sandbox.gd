extends Node3D

@export var box: MeshInstance3D
@export var nig: Button
@export var ger: Button

func _ready():
	nig.button_up.connect(change_color1)
	ger.button_up.connect(change_color2)

func change_color1():
	print("changing color 1")
	var mat = box.get_active_material(0).duplicate()
	mat.albedo_color = Color.GREEN
	box.set_surface_override_material(0, mat)

func change_color2():
	print("changing color 2")
	var mat = box.get_active_material(0).duplicate()
	mat.albedo_color = Color.RED
	box.set_surface_override_material(0, mat)
