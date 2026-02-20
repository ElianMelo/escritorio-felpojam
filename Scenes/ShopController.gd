extends Node3D

@onready var interface: InterfaceController = %Interface

@onready var buy_item: RigidBody3D = $BuyItem
@onready var sell_item: RigidBody3D = $SellItem
@onready var init_fight_button: Button = $"../Interface/ShopInterface/InitFightButton"

@onready var player_board_controller: PlayerBoardController = %PlayerBoardController

var isActive = false
var defaultBuyValue = 2
var defaultSellValue = 1

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	if !Global.firstItemBrought:
		init_fight_button.disabled = true
	OnGameStateChanged(Global.game_state)

func OnGameStateChanged(state: Global.GAME_STATE):
	match state:
		Global.GAME_STATE.SHOP:
			ShowShopItems()
		_:
			HideShopItems()
			
func ShowShopItems():
	buy_item.set_process(true)
	sell_item.set_process(true)
	buy_item.visible = true
	sell_item.visible = true
	isActive = true

func HideShopItems():
	buy_item.set_process(false)
	sell_item.set_process(false)
	buy_item.visible = false
	sell_item.visible = false
	isActive = false

func _on_buy_item_body_entered(body: Node) -> void:
	if !isActive: return
	var officeItem = body as OfficeItem
	if officeItem == null: return
	if officeItem.isPlayer:
		interface.ShowShopFeedbackMessage(\
			"Este item já é seu")
		return
	AttemptBuyItem(officeItem)
	pass # Replace with function body.

func _on_sell_item_body_entered(body: Node) -> void:
	if !isActive: return
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
		return
	if Global.coin < defaultBuyValue:
		interface.ShowShopFeedbackMessage(\
			"Moeda insuficiente para comprar esse item!!")
		return
	Global.coin -= defaultBuyValue
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
	Global.coin += defaultSellValue
	player_board_controller.DeletePlayerItem(officeItem)
	interface.UpdateCoinText()
	pass
