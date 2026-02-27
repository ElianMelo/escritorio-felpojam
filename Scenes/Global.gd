extends Node

enum GAME_STATE {
	PREBATTLE,
	BATTLE,
	SHOP,
	STAMP,
	POSTBATTLE,
	CINEMATIC
}

enum CINEMATIC_STATE {
	INITIAL,
	IT,
	SECURITY,
	BOSS,
	TRAINEE,
	RH
}

var player_max_health:float = 125
var enemy_max_health:float = 100

var player_health:float = 125
var enemy_health:float = 100
var player_health_increase:float = 25
var last_game_state:Global.GAME_STATE = Global.GAME_STATE.CINEMATIC
var game_state:Global.GAME_STATE = Global.GAME_STATE.CINEMATIC
var cinematic_state:Global.CINEMATIC_STATE = Global.CINEMATIC_STATE.INITIAL

var cinematic_title = "O cara do TI"
var cinematic_subtitle = "O mais nerd da turma"

var coin: int = 4
var firstItemBrought: bool = false
var isGamePaused = false

signal game_state_changed(state: Global.GAME_STATE)
signal cinematic_state_changed(state: Global.CINEMATIC_STATE)

func ChangeCinematicState(state: Global.CINEMATIC_STATE, \
	title: String, subtitle: String):
	cinematic_state = state
	cinematic_title = title
	cinematic_subtitle = subtitle
	emit_signal("cinematic_state_changed", state)
	
func RevertGameState():
	if game_state == last_game_state:
		ChangeGameState(Global.GAME_STATE.SHOP)
		return
	ChangeGameState(last_game_state)

func ChangeGameState(state: Global.GAME_STATE):
	last_game_state = game_state
	game_state = state
	if state == Global.GAME_STATE.POSTBATTLE:
		player_max_health += player_health_increase
	player_health = player_max_health
	enemy_health = enemy_max_health
	emit_signal("game_state_changed", state)

func GetColorByEffect(effect: Enums.EFFECT):
	match effect:
		Enums.EFFECT.HASTE:
			return Color.AQUAMARINE
		Enums.EFFECT.FREEZE:
			return Color.DARK_VIOLET
		Enums.EFFECT.SLOW:
			return Color.YELLOW
		Enums.EFFECT.CHARGE:
			return Color.SANDY_BROWN
		Enums.EFFECT.NONE:
			return Color.WHITE
