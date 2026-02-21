extends Node

enum GAME_STATE {
	PREBATTLE,
	BATTLE,
	SHOP,
	STAMP,
	POSTBATTLE
}

var player_max_health:float = 200
var enemy_max_health:float = 200

var player_health:float = 200
var enemy_health:float = 200
var game_state:Global.GAME_STATE = Global.GAME_STATE.SHOP

var coin: int = 4
var firstItemBrought: bool = false
var isGamePaused = false

signal game_state_changed(state: Global.GAME_STATE)

func ChangeGameState(state: Global.GAME_STATE):
	game_state = state
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
