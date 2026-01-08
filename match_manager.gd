extends Node3D
class_name MatchManager

enum MatchState {DEPLOY, BATTLE}
var match_state: MatchState = MatchState.DEPLOY

var board: GameBoard

@export var player_units: Array[ArmyUnit]
@export var admiral: AdmiralPanel

func _ready():
	admiral.speak("Good day commander. Deploy your units wisely, failure is not an option!")
	pass#board.board_state = GameBoard.BoardState.DEPLOY

func _process(_delta):
	pass
