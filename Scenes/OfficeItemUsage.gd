class_name OfficeItemUsage
extends Node3D

@onready var item_progress: ItemProgress = $"../ItemProgress"
@onready var office_item: OfficeItem = $".."

var modifier = 1

var duration = 99
var currentDuration = 0

var effectDuration = 0
var currentEffectDuration = 0
var canDoubleUse = false

var currentEffect: Enums.EFFECT = Enums.EFFECT.NONE

func SetDuration(durationData: float):
	duration = durationData

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)

func OnGameStateChanged(state:Global.GAME_STATE):
	currentDuration = 0
	currentEffectDuration = 0
	item_progress.set_current_progress(currentDuration / duration)

func _process(delta: float) -> void:
	if(Global.game_state != Global.GAME_STATE.BATTLE): return
	currentDuration += delta * modifier
	currentEffectDuration += delta
	item_progress.set_current_progress(currentDuration / duration)
	if currentEffectDuration >= effectDuration:
		currentEffectDuration = 0
		ReceiveEffect(Enums.EFFECT.NONE, 99999)
	if currentDuration >= duration:
		currentDuration = 0
		UseItem()
	pass

func ReceiveEffect(effect: Enums.EFFECT, effect_duration: float):
	item_progress.set_current_mode(effect)
	currentEffect = effect
	currentEffectDuration = 0
	effectDuration = effect_duration
	match effect:
		Enums.EFFECT.HASTE:
			modifier = 2
		Enums.EFFECT.SLOW:
			modifier = 0.5
		Enums.EFFECT.NONE:
			modifier = 1
		Enums.EFFECT.FREEZE:
			modifier = 0
		Enums.EFFECT.CHARGE:
			currentDuration += effect_duration
			effectDuration = 0.3
			if currentDuration <= duration: return
			currentDuration -= duration
	
func UseItem():
	office_item.use_item()
