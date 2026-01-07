extends HBoxContainer
class_name AdmiralPanel

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
