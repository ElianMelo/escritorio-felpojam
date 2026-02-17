class_name Tooltip
extends PanelContainer

const OFFSET: Vector2 = Vector2.ONE * 10.0
var opacity_tween: Tween = null

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	toggle(false)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func SetupTooltipData(itemData: OfficeItemData):
	rich_text_label.text = "[img=32]res://Sprites/Effects/Blunt.png[/img][br]"\
		+ itemData.name
	pass

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
