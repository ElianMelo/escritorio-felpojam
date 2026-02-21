extends Node3D

var winGold = 3
var loseGold = 2
var winText = "Vitória!"
var loseText = "Derrota!"

@onready var interface: InterfaceController = %Interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.enemy_health <= 0:
		WinBattle()
	if Global.player_health <= 0:
		LoseBattle()

func WinBattle():
	Global.coin += winGold
	interface.ChangePostBattleText(winText, \
		"Ganhou %s de moeda" % [winGold])
	PostGameCoroutine()
	pass

func LoseBattle():
	Global.coin += loseGold
	interface.ChangePostBattleText(loseText, \
		"Ganhou %s de moeda" % [loseGold])
	PostGameCoroutine()
	pass

func PostGameCoroutine():
	Global.ChangeGameState(Global.GAME_STATE.POSTBATTLE)
	await get_tree().create_timer(3.0).timeout
	Global.ChangeGameState(Global.GAME_STATE.STAMP)
