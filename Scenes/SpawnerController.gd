class_name SpawnerController
extends Node3D

const POPUP_TEXT = preload("uid://dp3ai8c76eee7")

func SpawnPopup(targetPosition: Vector3, effect: Enums.EFFECT):
	var instace = POPUP_TEXT.instantiate()
	add_child(instace)
	var popupText = instace as PopupText
	popupText.position = targetPosition
	popupText.SetupData(ConvertEffectToText(effect), effect)

func ConvertEffectToText(effect: Enums.EFFECT):
	match effect:
		Enums.EFFECT.HASTE:
			return "Tecnologico"
		Enums.EFFECT.SLOW:
			return "Colado"
		Enums.EFFECT.FREEZE:
			return "Contundente"
		Enums.EFFECT.CHARGE:
			return "Em branco"
