extends CanvasLayer

@export var demons_button: Button
@export var angels_button: Button
@export var aliens_button: Button
@export var humans_button: Button

func _ready():
	demons_button.button_up.connect(_on_demons_button_up)
	angels_button.button_up.connect(_on_angels_button_up)
	aliens_button.button_up.connect(_on_aliens_button_up)
	humans_button.button_up.connect(_on_humans_button_up)

func _on_demons_button_up():
	PlayerArmy.army_type = PlayerArmy.ArmyType.DEMONS
	start_battle()

func _on_angels_button_up():
	PlayerArmy.army_type = PlayerArmy.ArmyType.ANGELS
	start_battle()

func _on_aliens_button_up():
	PlayerArmy.army_type = PlayerArmy.ArmyType.ALIENS
	start_battle()

func _on_humans_button_up():
	PlayerArmy.army_type = PlayerArmy.ArmyType.HUMANS
	start_battle()

func start_battle():
	get_tree().change_scene_to_file("res://draft_army_screen.tscn")
