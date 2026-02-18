class_name OfficeItemData
extends Resource

@export var name: String
@export var reload: float
@export var value: float
@export var canDamage: bool
@export var damage: int
@export var canSlow: bool
@export var slowDuration: float
@export var canFreeze: bool
@export var freezeDuration: float
@export var canHaste: bool
@export var hasteDuration: float
@export var canCharge: bool
@export var chargeSeconds: float
@export var effectTarget: Enums.EFFECT_TARGET = Enums.EFFECT_TARGET.RANDOM
@export var isMarked: bool
@export var markedEffect: Enums.EFFECT = Enums.EFFECT.NONE
@export var meshResource: Mesh

func _init(p_name = "", p_reload = 0.0, p_canDamage = false,\
	p_damage = 0, p_canSlow = false, p_slowDuration = 0.0,\
	p_canFreeze = false, p_freezeDuration = 0.0, p_canHaste = false,\
	p_canCharge = false, p_chargeSeconds = 0.0, \
	p_hasteDuration = 0.0, p_effectTarget = Enums.EFFECT_TARGET.RANDOM, \
	p_meshResource: Mesh = null,
	p_value = 0.0):
	name = p_name
	value = p_value
	reload = p_reload
	canDamage = p_canDamage
	damage = p_damage
	canSlow = p_canSlow
	slowDuration = p_slowDuration
	canFreeze = p_canFreeze
	freezeDuration = p_freezeDuration
	canHaste = p_canHaste
	canCharge = p_canCharge
	chargeSeconds = p_chargeSeconds
	hasteDuration = p_hasteDuration
	effectTarget = p_effectTarget
	meshResource = p_meshResource
	
