class_name MenuInterface
extends Control

var isEnabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Switch():
	isEnabled = !isEnabled
	if isEnabled:
		ShowVisuals()
	else:
		HideVisuals()

func ShowVisuals():
	self.visible = true
	Engine.time_scale = 0
	Global.isGamePaused = true
	Global.ChangeCinematicState(Global.CINEMATIC_STATE.INITIAL, "Batalha de Escritorio",
		"Fuja")
	Global.ChangeGameState(Global.GAME_STATE.CINEMATIC)

func HideVisuals():
	Engine.time_scale = 1
	Global.isGamePaused = false
	self.visible = false
	Global.RevertGameState()

func _on_play_button_pressed() -> void:
	Switch()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
