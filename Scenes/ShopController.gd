extends Node3D

@onready var interface: InterfaceController = %Interface

@onready var buy_item: RigidBody3D = $BuyItem
@onready var sell_item: RigidBody3D = $SellItem
@onready var init_fight_button: Button = $"../Interface/ShopInterface/InitFightButton"

@onready var player_board_controller: PlayerBoardController = %PlayerBoardController

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	if !Global.firstItemBrought:
		init_fight_button.disabled = true
	OnGameStateChanged(Global.game_state)

func OnGameStateChanged(state: Global.GAME_STATE):
	match state:
		Global.GAME_STATE.BATTLE:
			pass
		Global.GAME_STATE.SHOP:
			pass

func _on_buy_item_body_entered(body: Node) -> void:
	var officeItem = body as OfficeItem
	if officeItem == null: return
	if officeItem.isPlayer:
		interface.ShowShopFeedbackMessage(\
			"Este item já é seu")
		return
	AttemptBuyItem(officeItem)
	pass # Replace with function body.

func _on_sell_item_body_entered(body: Node) -> void:
	var officeItem = body as OfficeItem
	if officeItem == null: return
	if officeItem.isShop: 
		interface.ShowShopFeedbackMessage(\
			"Este item não é seu")
		return
	SellItem(officeItem)
	pass # Replace with function body.

func AttemptBuyItem(officeItem: OfficeItem):
	if player_board_controller.PlayerAmountItems() == 5:
		interface.ShowShopFeedbackMessage(\
			"Você só pode ter 5 itens")
	if Global.coin < officeItem.office_item_data.value:
		interface.ShowShopFeedbackMessage(\
			"Moeda insuficiente para comprar esse item!!")
		return
	Global.coin -= officeItem.office_item_data.value
	officeItem.isShop = false
	officeItem.isPlayer = true
	if !Global.firstItemBrought:
		Global.firstItemBrought = true
		init_fight_button.disabled = false
	interface.ShowShopFeedbackMessage(\
		"Item comprado com sucesso!")
	player_board_controller.AddPlayerItem(officeItem)
	player_board_controller.DeleteShopItem(officeItem)
	interface.UpdateCoinText()
	pass

func SellItem(officeItem: OfficeItem):
	if player_board_controller.PlayerAmountItems() == 1:
		interface.ShowShopFeedbackMessage(\
			"Deve ter ao menos 1 item")
		return
	interface.ShowShopFeedbackMessage(\
			"Item vendido com sucesso!")
	Global.coin += officeItem.office_item_data.value
	player_board_controller.DeletePlayerItem(officeItem)
	interface.UpdateCoinText()
	pass
