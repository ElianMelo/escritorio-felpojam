class_name StampEffectData
extends Resource

@export var stampEffect: Enums.STAMP_EFFECT = Enums.STAMP_EFFECT.DAMAGE
@export var stampEffectValue: float

func _init(p_stampEffect: Enums.STAMP_EFFECT, \
	p_stampEffectValue: float):
	stampEffect = p_stampEffect
	stampEffectValue = p_stampEffectValue

func SetupBaseValueForNoFirstTime(stampEffect: Enums.STAMP_EFFECT):
	match stampEffect:
		Enums.STAMP_EFFECT.DAMAGE:
			return 5
		Enums.STAMP_EFFECT.HASTE:
			return 2
		Enums.STAMP_EFFECT.SLOW:
			return 2
		Enums.STAMP_EFFECT.CHARGE:
			return 1
		Enums.STAMP_EFFECT.FREEZE:
			return 1
		_:
			return 5
