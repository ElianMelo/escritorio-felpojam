class_name SpawnerController
extends Node3D

const POPUP_TEXT = preload("uid://dp3ai8c76eee7")
const EFFECT_VFX_PARTICLE = preload("uid://rewbc8f7wodn")

const BLUNT_MAT = preload("uid://dvs7c4x8raf35")
const DAMAGE_MAT = preload("uid://duwj0cgy27oo2")
const GLUE_MAT = preload("uid://2g8g0q4siy1x")
const TECH_MAT = preload("uid://bgidwjo2qnax2")
const WHITE_MAT = preload("uid://btpnypv431lwf")

func SpawnPopup(targetPosition: Vector3, effect: Enums.EFFECT):
	var instace = POPUP_TEXT.instantiate()
	add_child(instace)
	var popupText = instace as PopupText
	popupText.position = targetPosition
	popupText.SetupData(ConvertEffectToText(effect), effect)

func SpawnParticle(targetPosition: Vector3, effect: Enums.EFFECT):
	var instace = EFFECT_VFX_PARTICLE.instantiate()
	add_child(instace)
	var vfxValue = instace as EffectVFXParticle
	vfxValue.position = targetPosition
	vfxValue.SetupEffectVFX(ConvertEffectToMaterial(effect))

func ConvertEffectToMaterial(effect: Enums.EFFECT):
	match effect:
		Enums.EFFECT.HASTE:
			return TECH_MAT
		Enums.EFFECT.SLOW:
			return GLUE_MAT
		Enums.EFFECT.FREEZE:
			return BLUNT_MAT
		Enums.EFFECT.CHARGE:
			return WHITE_MAT

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
