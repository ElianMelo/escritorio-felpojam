class_name InterfaceController
extends Node3D

@onready var player_health_progress_bar: TextureProgressBar = $BattleInterface/PlayerHealthProgressBar
@onready var player_health: Label = $BattleInterface/PlayerHealthLabel
@onready var enemy_health_progress_bar: TextureProgressBar = $BattleInterface/EnemyHealthProgressBar
@onready var enemy_health: Label = $BattleInterface/EnemyHealthLabel

# ShopInterface
@onready var coin_label: Label = $ShopInterface/CoinLabel
@onready var shop_message: Label = $ShopInterface/ShopMessage

# StampInterface
@onready var init_shop_stamp_button: Button = $StampInterface/InitShopStampButton
@onready var stamp_text_label: RichTextLabel = $StampInterface/StampDataBox/MarginContainer/RichTextLabel
@onready var stamp_message: Label = $StampInterface/StampMessage

@onready var battle_interface: Control = $BattleInterface
@onready var shop_interface: Control = $ShopInterface
@onready var stamp_interface: Control = $StampInterface
@onready var menu_interface: MenuInterface = $MenuInterface
@onready var tooltip: TooltipItem = $TooltipBase/Tooltip

var shop_message_tween: Tween

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape_key_button"):
		SwitchMenuInterface()
	pass

func SwitchMenuInterface():
	menu_interface.Switch()

func OnGameStateChanged(state: Global.GAME_STATE):
	DisplayEnemyHealth()
	DisplayPlayerHealth()
	UpdateCoinText()
	DisableAllInterfaces()
	match state:
		Global.GAME_STATE.BATTLE:
			battle_interface.visible = true
		Global.GAME_STATE.PREBATTLE:
			battle_interface.visible = true
		Global.GAME_STATE.SHOP:
			shop_interface.visible = true
		Global.GAME_STATE.STAMP:
			stamp_interface.visible = true
			init_shop_stamp_button.disabled = true

func DisableAllInterfaces():
	battle_interface.visible = false
	shop_interface.visible = false
	stamp_interface.visible = false
	menu_interface.visible = false

func DisplayEnemyHealth():
	enemy_health.text = "Vida: " + str(Global.enemy_health)
	enemy_health_progress_bar.value = Global.enemy_health / Global.enemy_max_health
	pass

func DisplayPlayerHealth():
	player_health.text = "Vida: " + str(Global.player_health)
	player_health_progress_bar.value = Global.player_health / Global.player_max_health

func UpdateCoinText():
	coin_label.text = "Moeda: " + str(Global.coin)

func EnableButtonStamp():
	init_shop_stamp_button.disabled = false

func ShowShopFeedbackMessage(message: String):
	shop_message.text = message
	await ShopMessageTweenHandle().finished
	shop_message.text = ""
	set_font_color(Color.WHITE)

func ShopMessageTweenHandle():
	if shop_message_tween: 
		shop_message_tween.kill()
		set_font_color(Color.WHITE)
	shop_message_tween = get_tree().create_tween()
	var current_color = Color(255,255,255,255)
	shop_message_tween.tween_method(
		set_font_color,
		current_color,
		Color(255,255,255,0),
		2
	)
	return shop_message_tween

func set_font_color(color:Color):
	shop_message.add_theme_color_override("font_color", color)

func DisplayTooltipWithData(officeItem: OfficeItem):
	tooltip.SetupTooltipData(officeItem)
	tooltip.toggle(true)
	pass

func HideTooltip():
	tooltip.toggle(false)
	pass

func _on_stop_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.STAMP)

func _on_init_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.PREBATTLE)

func _on_init_shop_stamp_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.SHOP)

func SetupStampData(stampEffect: Enums.STAMP_EFFECT, stampValue: float):
	stamp_text_label.text = StampTextData(stampEffect, stampValue)
	pass

func ShowStampFeedbackMessage(message: String):
	stamp_message.text = message

func StampTextData(stampEffect: Enums.STAMP_EFFECT, stampValue: float):
	match stampEffect:
		Enums.STAMP_EFFECT.DAMAGE:
			return "Cortante %s causa %d de dano [br]" \
				% [GetImageByStampEffect(stampEffect), stampValue]
		Enums.STAMP_EFFECT.HASTE:
			return "Tecnologico %s causa por %d segundos [br]" \
				% [GetImageByStampEffect(stampEffect), stampValue]
		Enums.STAMP_EFFECT.SLOW:
			return "Cola %s causa por %d segundos [br]" \
				% [GetImageByStampEffect(stampEffect), stampValue]
		Enums.STAMP_EFFECT.CHARGE:
			return "Em branco %s causa por %d segundos [br]" \
				% [GetImageByStampEffect(stampEffect), stampValue]
		Enums.STAMP_EFFECT.FREEZE:
			return "Contundente %s causa por %d segundos [br]" \
				% [GetImageByStampEffect(stampEffect), stampValue]
	pass

const BLUNT_IMAGE = "[img=16]res://Sprites/Effects/Blunt.png[/img]"
const GLUE_IMAGE = "[img=16]res://Sprites/Effects/Glue.png[/img]"
const DAMAGE_IMAGE = "[img=16]res://Sprites/Effects/Damage.png[/img]"
const TECH_IMAGE = "[img=16]res://Sprites/Effects/Tech.png[/img]"
const WHITE_IMAGE = "[img=16]res://Sprites/Effects/White.png[/img]"

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

func GetImageByStampEffect(effect: Enums.STAMP_EFFECT):
	match effect:
		Enums.STAMP_EFFECT.DAMAGE:
			return DAMAGE_IMAGE
		Enums.STAMP_EFFECT.SLOW:
			return GLUE_IMAGE
		Enums.STAMP_EFFECT.HASTE:
			return TECH_IMAGE
		Enums.STAMP_EFFECT.CHARGE:
			return WHITE_IMAGE
		Enums.STAMP_EFFECT.FREEZE:
			return BLUNT_IMAGE
