class_name WinGameInterface
extends Control

const LOSE_GAME_RESULT = preload("uid://dvxqd13ptjw4e")
const WIN_GAME_RESULT = preload("uid://b2lbyhxqn6q47")
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func ShowVisuals(isWin: bool):
	if isWin:
		texture_rect.texture = WIN_GAME_RESULT
		label.text = "Vitória, você pediu demissão com estilo"
	else:
		texture_rect.texture = LOSE_GAME_RESULT
		label.text = "Derrota, a demissão nunca foi tão humilhante"


func _on_quit_button_pressed() -> void:
	get_tree().quit()
