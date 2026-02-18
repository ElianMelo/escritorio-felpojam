class_name InterfaceController
extends Node3D

@onready var player_health_progress_bar: TextureProgressBar = $BattleInterface/PlayerHealthProgressBar
@onready var player_health: Label = $BattleInterface/PlayerHealthLabel
@onready var enemy_health_progress_bar: TextureProgressBar = $BattleInterface/EnemyHealthProgressBar
@onready var enemy_health: Label = $BattleInterface/EnemyHealthLabel

# ShopInterface
@onready var coin_label: Label = $ShopInterface/CoinLabel
@onready var shop_message: Label = $ShopInterface/ShopMessage

@onready var battle_interface: Control = $BattleInterface
@onready var shop_interface: Control = $ShopInterface
@onready var tooltip: TooltipItem = $TooltipBase/Tooltip

var shop_message_tween: Tween

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

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

func DisableAllInterfaces():
	battle_interface.visible = false
	shop_interface.visible = false

func DisplayEnemyHealth():
	enemy_health.text = "Vida: " + str(Global.enemy_health)
	enemy_health_progress_bar.value = Global.enemy_health / Global.enemy_max_health
	pass

func DisplayPlayerHealth():
	player_health.text = "Vida: " + str(Global.player_health)
	player_health_progress_bar.value = Global.player_health / Global.player_max_health

func UpdateCoinText():
	coin_label.text = "Moeda: " + str(Global.coin)
	pass

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

func DisplayTooltipWithData(itemData: OfficeItemData):
	tooltip.SetupTooltipData(itemData)
	tooltip.toggle(true)
	pass

func HideTooltip():
	tooltip.toggle(false)
	pass

func _on_stop_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.STAMP)

func _on_init_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.PREBATTLE)
