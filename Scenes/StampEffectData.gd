class_name StampEffectData
extends Resource

@export var stampEffect: Enums.STAMP_EFFECT = Enums.STAMP_EFFECT.DAMAGE
@export var stampEffectValue: float

func _init(p_stampEffect: Enums.STAMP_EFFECT = Enums.STAMP_EFFECT.DAMAGE, \
	p_stampEffectValue: float = 0.0):
	stampEffect = p_stampEffect
	stampEffectValue = p_stampEffectValue
