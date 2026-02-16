class_name OfficeItemData
extends Resource

@export var name: String
@export var reload: float
@export var canDamage: bool
@export var damage: int
@export var canSlow: bool
@export var slowDuration: float
@export var canFreeze: bool
@export var freezeDuration: float
@export var canHaste: bool
@export var hasteDuration: float
@export var effectTarget: Enums.EFFECT_TARGET = Enums.EFFECT_TARGET.RANDOM

func _init(p_name = "", p_reload = 0.0, p_canDamage = false,\
	p_damage = 0, p_canSlow = false, p_slowDuration = 0.0,\
	p_canFreeze = false, p_freezeDuration = 0.0, p_canHaste = false,\
	p_hasteDuration = 0.0, p_effectTarget = Enums.EFFECT_TARGET.RANDOM):
	name = p_name
	reload = p_reload
	canDamage = p_canDamage
	damage = p_damage
	canSlow = p_canSlow
	slowDuration = p_slowDuration
	canFreeze = p_canFreeze
	freezeDuration = p_freezeDuration
	canHaste = p_canHaste
	hasteDuration = p_hasteDuration
	effectTarget = p_effectTarget
	
	
