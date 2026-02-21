class_name StampController
extends Node3D

@onready var stampler: Strampler = $Stampler
@onready var interface: InterfaceController = %Interface
@export var stampListEffects: Array[StampEffectData]
@export var godotBugKeepThis: Array[OfficeItemData]

const GLUE_DECAL = preload("uid://cej3m5yjrc7dk")
const DAMAGE_DECAL = preload("uid://x2k40u7ho4x2")
const STUN_DECAL = preload("uid://de24ieshk4y2f")
const TECH_DECAL = preload("uid://cpf7vsp400lig")
const WHITE_DECAL = preload("uid://dvjebtwd8unp6")

var currentStampleData: StampEffectData
var isActive: bool = false
var canStample: bool = false

var stamplerInitialPosition: Vector3 = Vector3(0.043,1.057,-2.519)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OnGameStateChanged(state: Global.GAME_STATE):
	match state:
		Global.GAME_STATE.STAMP:
			ShowStampler()
		_:
			HideStampler()

func ShowStampler():
	stampler.set_process(true)
	stampler.visible = true
	isActive = true
	canStample = true
	interface.ShowStampFeedbackMessage("Carimbe um item!")
	currentStampleData = stampListEffects[rng.randi_range(0, stampListEffects.size()-1)]
	interface.SetupStampData(currentStampleData.stampEffect, currentStampleData.stampEffectValue)
	ResetStamplerPosition()

func HideStampler():
	stampler.set_process(false)
	stampler.visible = false
	isActive = false
	canStample = false

func ResetStamplerPosition():
	stampler.position = stamplerInitialPosition
	pass

func _on_stampler_body_entered(body: Node) -> void:
	if !isActive: return
	if !canStample: return
	var officeItem = body as OfficeItem
	if officeItem == null: return
	if !stampler.isDragging: return
	stampler.PlayAnimation()
	await get_tree().create_timer(0.5).timeout
	officeItem.AddStampEffect(currentStampleData.stampEffect, currentStampleData.stampEffectValue)
	officeItem.SetDecal(GetDecalByStampEffect(currentStampleData.stampEffect))
	canStample = false
	interface.EnableButtonStamp()
	interface.ShowStampFeedbackMessage("Item carimbado com sucesso!")

func GetDecalByStampEffect(stampEffect: Enums.STAMP_EFFECT):
	match stampEffect:
		Enums.STAMP_EFFECT.DAMAGE:
			return DAMAGE_DECAL
		Enums.STAMP_EFFECT.SLOW:
			return GLUE_DECAL
		Enums.STAMP_EFFECT.HASTE:
			return TECH_DECAL
		Enums.STAMP_EFFECT.CHARGE:
			return WHITE_DECAL
		Enums.STAMP_EFFECT.FREEZE:
			return STUN_DECAL
