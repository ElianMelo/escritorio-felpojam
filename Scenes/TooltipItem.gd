class_name TooltipItem
extends PanelContainer

const OFFSET: Vector2 = Vector2(1,-10) * 10.0
var opacity_tween: Tween = null

@onready var interface: InterfaceController = %Interface

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var margin_container: MarginContainer = $MarginContainer
@onready var tooltip: TooltipItem = $"."
@onready var tooltip_base: Control = $".."

var baseWidght: float =  300
var baseHeight: float =  140

var currentOfficeItem: OfficeItem = null

func _ready() -> void:
	toggle(false)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func ResetOriginalSize():
	tooltip.size = Vector2(baseWidght, baseHeight)

func SetupTooltipData(officeItem: OfficeItem):
	ResetOriginalSize()
	var itemData = officeItem.office_item_data
	var damageItem = ""
	if itemData.canDamage:
		damageItem = "Causa %s de dano [br]" % [itemData.damage]
	var effectsText = BuiltEffectsText(itemData)
	var stampEffectsText = BuiltStampEffectsText(officeItem)
	rich_text_label.text = \
		"[font_size=28][b] " + itemData.name  + "[/b][/font_size][br]\n Recarga: " + str(itemData.reload) + "[br]\n" \
		+ damageItem \
		+ effectsText + "[br]" \
		+ stampEffectsText + "[br]"
	pass

func BuiltStampEffectsText(officeItem: OfficeItem):
	var effectsString: String = ""
	if officeItem.stampList.size() == 0:
		return effectsString
	effectsString += "\n[font_size=14] Carimbos [/font_size] [br]"
	for i in range(0, officeItem.stampList.size()):
		effectsString += interface.StampTextData(\
			officeItem.stampList[i].stampEffect, officeItem.stampList[i].stampEffectValue)
	return effectsString

func BuiltEffectsText(itemData: OfficeItemData):
	var effectsString: String = ""
	if itemData.canCharge:
		effectsString += "Aplica %s Em branco por %s segundos[br]" \
		% [interface.GetImageByEffect(Enums.EFFECT.CHARGE), itemData.chargeSeconds]
	if itemData.canHaste:
		effectsString += "Aplica %s Tecnologico por %s segundos[br]" \
		% [interface.GetImageByEffect(Enums.EFFECT.HASTE), itemData.hasteDuration]
	if itemData.canSlow:
		effectsString += "Aplica %s Cola por %s segundos[br]" \
		% [interface.GetImageByEffect(Enums.EFFECT.SLOW), itemData.slowDuration]
	if itemData.canFreeze:
		effectsString += "Aplica %s Contundente por %s segundos[br]" \
		% [interface.GetImageByEffect(Enums.EFFECT.FREEZE), itemData.freezeDuration]
	return effectsString

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
