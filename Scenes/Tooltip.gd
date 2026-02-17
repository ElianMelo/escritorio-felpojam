class_name Tooltip
extends PanelContainer

const OFFSET: Vector2 = Vector2.ONE * 10.0
var opacity_tween: Tween = null

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

const BLUNT_IMAGE = "[img=32]res://Sprites/Effects/Blunt.png[/img]"
const GLUE_IMAGE = "[img=32]res://Sprites/Effects/Glue.png[/img]"
const TECH_IMAGE = "[img=32]res://Sprites/Effects/Tech.png[/img]"
const WHITE_IMAGE = "[img=32]res://Sprites/Effects/White.png[/img]"

func _ready() -> void:
	toggle(false)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func SetupTooltipData(itemData: OfficeItemData):
	var effectsText = BuiltEffectsText(itemData)
	rich_text_label.text = \
		itemData.name  + " " + str(itemData.reload) + "[br]" \
		+ effectsText + "[br]"
	pass

func BuiltEffectsText(itemData: OfficeItemData):
	var effectsString: String = ""
	if itemData.canCharge:
		effectsString += "Causa %s Em branco por %s segundos" \
		% [GetImageByEffect(Enums.EFFECT.CHARGE), itemData.chargeSeconds]
	if itemData.canHaste:
		effectsString += "Causa %s Tecnologico por %s segundos" \
		% [GetImageByEffect(Enums.EFFECT.HASTE), itemData.hasteDuration]
	if itemData.canSlow:
		effectsString += "Causa %s Cola por %s segundos" \
		% [GetImageByEffect(Enums.EFFECT.SLOW), itemData.slowDuration]
	if itemData.canFreeze:
		effectsString += "Causa %s Contundente por %s segundos" \
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
