extends Node3D

@onready var item_progress: ItemProgress = $"../ItemProgress"

var modifier = 1

var duration = 5
var currentDuration = 0

var effectDuration = 0
var currentEffectDuration = 0

var currentEffect: Enums.EFFECT = Enums.EFFECT.NONE

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("g_key_button"):
		if currentEffect == Enums.EFFECT.SLOW:
			ReceiveEffect(Enums.EFFECT.HASTE)
		else:
			ReceiveEffect(Enums.EFFECT.SLOW)
	currentDuration += delta * modifier
	item_progress.set_current_progress(currentDuration / duration)
	if currentDuration >= duration:
		currentDuration = 0
		UseItem()
	pass

func ReceiveEffect(effect: Enums.EFFECT):
	item_progress.set_current_mode(effect)
	currentEffect = effect
	match effect:
		Enums.EFFECT.HASTE:
			modifier = 2
		Enums.EFFECT.SLOW:
			modifier = 0.5
		Enums.EFFECT.NONE:
			modifier = 1
		Enums.EFFECT.FREEZE:
			modifier = 0
	
func UseItem():
	pass

func ChangeColor():
	pass
