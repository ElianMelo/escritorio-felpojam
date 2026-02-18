class_name Tooltip
extends PanelContainer

const OFFSET: Vector2 = Vector2(1,-10) * 10.0
var opacity_tween: Tween = null

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var margin_container: MarginContainer = $MarginContainer
@onready var tooltip: Tooltip = $"."
@onready var tooltip_base: Control = $".."

var baseWidght: float =  300
var baseHeight: float =  140

const BLUNT_IMAGE = "[img=16]res://Sprites/Effects/Blunt.png[/img]"
const GLUE_IMAGE = "[img=16]res://Sprites/Effects/Glue.png[/img]"
const TECH_IMAGE = "[img=16]res://Sprites/Effects/Tech.png[/img]"
const WHITE_IMAGE = "[img=16]res://Sprites/Effects/White.png[/img]"

func _ready() -> void:
	toggle(false)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func ResetOriginalSize():
	tooltip.size = Vector2(baseWidght, baseHeight)

func SetupTooltipData(itemData: OfficeItemData):
	ResetOriginalSize()
	var damageItem = ""
	if itemData.canDamage:
		damageItem = "Causa %s de dano [br]" % [itemData.damage]
	var effectsText = BuiltEffectsText(itemData)
	rich_text_label.text = \
		"-[b] " + itemData.name  + " -[/b][br] Recarga: " + str(itemData.reload) + "[br]\n" \
		+ damageItem \
		+ effectsText + "[br]"
	pass

func BuiltEffectsText(itemData: OfficeItemData):
	var effectsString: String = ""
	if itemData.canCharge:
		effectsString += "Aplica %s Em branco por %s segundos[br]" \
		% [GetImageByEffect(Enums.EFFECT.CHARGE), itemData.chargeSeconds]
	if itemData.canHaste:
		effectsString += "Aplica %s Tecnologico por %s segundos[br]" \
		% [GetImageByEffect(Enums.EFFECT.HASTE), itemData.hasteDuration]
	if itemData.canSlow:
		effectsString += "Aplica %s Cola por %s segundos[br]" \
		% [GetImageByEffect(Enums.EFFECT.SLOW), itemData.slowDuration]
	if itemData.canFreeze:
		effectsString += "Aplica %s Contundente por %s segundos[br]" \
		% [GetImageByEffect(Enums.EFFECT.FREEZE), itemData.freezeDuration]
	return effectsString

func GetImageByEffect(effect: Enums.EFFECT):
	match effect:
		Enums.EFFECT.SLOW:
			return GLUE_IMAGE
		Enums.EFFECT.HASTE:
			return TECH_IMAGE
		Enums.EFFECT.FREEZE:
			return BLUNT_IMAGE
		Enums.EFFECT.CHARGE:
			return WHITE_IMAGE

func toggle(on: bool):
	ResetOriginalSize()
	if on:
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()

func tween_opacity(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.2)
	return opacity_tween
