class_name InterfaceController
extends Node3D

@onready var player_health_progress_bar: TextureProgressBar = $BattleInterface/PlayerHealthProgressBar
@onready var player_health: Label = $BattleInterface/PlayerHealthLabel
@onready var enemy_health_progress_bar: TextureProgressBar = $BattleInterface/EnemyHealthProgressBar
@onready var enemy_health: Label = $BattleInterface/EnemyHealthLabel

@onready var battle_interface: Control = $BattleInterface
@onready var shop_interface: Control = $ShopInterface
@onready var tooltip: Tooltip = $TooltipBase/Tooltip

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

func OnGameStateChanged(state: Global.GAME_STATE):
	DisplayEnemyHealth()
	DisplayPlayerHealth()
	DisableAllInterfaces()
	match state:
		Global.GAME_STATE.BATTLE:
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

func DisplayTooltipWithData(itemData: OfficeItemData):
	tooltip.SetupTooltipData(itemData)
	tooltip.toggle(true)
	pass

func HideTooltip():
	tooltip.toggle(false)
	pass

func _on_stop_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.SHOP)

func _on_init_fight_button_pressed() -> void:
	Global.ChangeGameState(Global.GAME_STATE.BATTLE)
