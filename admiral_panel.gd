extends HBoxContainer
class_name AdmiralPanel

@export var portrait: TextureRect
@export var speech_text: RichTextLabel
@export var speech_speed: float = 0.05
var speech_index: int = 0
var speech: String
var speaking: bool = false
var timer: float = 0

func _process(delta):
	if(!speaking):
		return
	timer += delta
	if(timer >= speech_speed):
		timer = 0
		speech_index += 1
		speech_text.text = speech.substr(0, speech_index)
		if(speech_index >= speech.length()):
			speaking = false

func speak(_speech):
	speech_index = 0
	speech = _speech
	speaking = true

func set_portrait():
	match(PlayerArmy.army_type):
		PlayerArmy.ArmyType.DEMONS:
			portrait.texture = UnitInfo.demon_admiral_portrait
		PlayerArmy.ArmyType.ANGELS:
			portrait.texture = UnitInfo.angel_admiral_portrait
		PlayerArmy.ArmyType.ALIENS:
			portrait.texture = UnitInfo.alien_admiral_portrait
		PlayerArmy.ArmyType.HUMANS:
			portrait.texture = UnitInfo.human_admiral_portrait
