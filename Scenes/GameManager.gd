extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("g_key_button"):
		if Global.game_state == Global.GAME_STATE.BATTLE:
			Global.ChangeGameState(Global.GAME_STATE.SHOP)
			return
		if Global.game_state == Global.GAME_STATE.SHOP:
			Global.ChangeGameState(Global.GAME_STATE.BATTLE)
			return
	pass
