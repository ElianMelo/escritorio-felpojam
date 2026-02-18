class_name PlayerBoardController
extends Node3D

@onready var office_item: OfficeItem = $"../../OfficeItem"
@onready var interface: InterfaceController = %Interface
@onready var camera: Camera3D = %MainCamera3D
@export var office_item_data: Array[OfficeItemData]
@onready var stamp: StampController = %Stamp

@export var enemy_data: EnemyData

var player_office_items: Array[OfficeItem]
var enemy_office_items: Array[OfficeItem]
var shop_office_items: Array[OfficeItem]

var isShop = false

var rng = RandomNumberGenerator.new()

const OFFICE_ITEM = preload("res://Prefabs/OfficeItem.tscn")

var currentXOffset = -2
var currentZOffset = 2

# Const
const offsetIncrease = 2
const xInitialOffset = -4
const zInitialOffsetEnemy = -2
const zInitialOffsetPlayer = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)
	# DebugInitObjects()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("r_key_button"):
		ResetPositions()
		pass
	pass

func ResetPositions():
	stamp.ResetStamplerPosition()
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetEnemy
	for i in range(0, shop_office_items.size()):
		shop_office_items[i].position = \
			Vector3(currentXOffset, 0, currentZOffset)
		shop_office_items[i].rotation = Vector3.ZERO
		currentXOffset += offsetIncrease
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetEnemy
	for i in range(0, enemy_office_items.size()):
		enemy_office_items[i].position = \
			Vector3(currentXOffset, 0, currentZOffset)
		enemy_office_items[i].rotation = Vector3.ZERO
		currentXOffset += offsetIncrease
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetPlayer
	for i in range(0, player_office_items.size()):
		player_office_items[i].position = \
			Vector3(currentXOffset, 0, currentZOffset)
		player_office_items[i].rotation = Vector3.ZERO
		currentXOffset += offsetIncrease
	pass

func OnGameStateChanged(state: Global.GAME_STATE):
	isShop = false
	match state:
		Global.GAME_STATE.PREBATTLE:
			CleanShopObjects()
			CreateEnemyObjects()
			Global.ChangeGameState(Global.GAME_STATE.BATTLE)
		Global.GAME_STATE.BATTLE:
			pass
		Global.GAME_STATE.STAMP:
			CleanEnemyObjects()
		Global.GAME_STATE.SHOP:
			isShop = true
			CleanEnemyObjects()
			InitShopObjects()

func CleanShopObjects():
	for i in range(0, shop_office_items.size()):
		shop_office_items[i].queue_free()
	shop_office_items.clear()

func CleanEnemyObjects():
	for i in range(0, enemy_office_items.size()):
		enemy_office_items[i].queue_free()
	enemy_office_items.clear()

func CreateEnemyObjects():
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetEnemy
	for i in range(0, 5):
		InstantiateOfficeItem(false)
		currentXOffset += offsetIncrease

func InitShopObjects():
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetEnemy
	for i in range(0, 5):
		InstantiateOfficeItem(false, true)
		currentXOffset += offsetIncrease

func DebugInitObjects():
	currentXOffset = xInitialOffset
	for i in range(0, 2):
		InstantiateOfficeItem(true)
		currentXOffset += offsetIncrease
	currentXOffset = xInitialOffset
	currentZOffset = zInitialOffsetPlayer
	for i in range(0, 4):
		InstantiateOfficeItem(false)
		currentXOffset += offsetIncrease
	OrderArrayBasedOnPosition()

func OrderArrayBasedOnPosition():
	#player_office_items.sort_custom(func(a, b): return a.position.x[1] > b.position.x[1])
	#enemy_office_items.sort_custom(func(a, b): return a.position.x[1] > b.position.x[1])
	pass

func InstantiateOfficeItem(isPlayer: bool, isShop: bool = false):
	var instace = OFFICE_ITEM.instantiate()
	add_child(instace)
	var officeItem = instace as OfficeItem
	if officeItem == null: return
	officeItem.position += Vector3(currentXOffset, 0, currentZOffset)
	officeItem.ResetRotation()
	officeItem.SetupData(camera, 
		office_item_data[rng.randi_range(0, office_item_data.size()-1 )], 
		isPlayer, isShop)
	if isPlayer:
		player_office_items.push_back(officeItem)
	elif isShop:
		shop_office_items.push_back(officeItem)
	else:
		enemy_office_items.push_back(officeItem)
	SetupOfficeItem(officeItem)

func SetupOfficeItem(currentOfficeItem: OfficeItem):
	currentOfficeItem.connect("item_damage_used", OnItemDamageUsed)
	currentOfficeItem.connect("item_slow_used", OnItemSlowUsed)
	currentOfficeItem.connect("item_haste_used", OnItemHasteUsed)
	currentOfficeItem.connect("item_freeze_used", OnItemFreezeUsed)
	currentOfficeItem.connect("item_charge_used", OnItemChargeUsed)
	currentOfficeItem.connect("item_mouse_entered", OnItemMouseEntered)
	currentOfficeItem.connect("item_mouse_exited", OnItemMouseExited)

func OnItemMouseEntered(officeItem: OfficeItem):
	interface.DisplayTooltipWithData(officeItem)
	
func OnItemMouseExited():
	interface.HideTooltip()

func OnItemDamageUsed(damage: int, isPlayer: bool):
	if isPlayer:
		Global.enemy_health -= damage
		if Global.enemy_health <= 0:
			Global.enemy_health = 0
		interface.DisplayEnemyHealth()
	else:
		Global.player_health -= damage
		if Global.player_health <= 0:
			Global.player_health = 0
		interface.DisplayPlayerHealth()
	pass

func OnItemSlowUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	# inverse to get other items
	var randomItem: OfficeItem = GetRandomItemBasedOnPlayer(!isPlayer)
	randomItem.ReceiveEffect(Enums.EFFECT.SLOW, duration)

func OnItemHasteUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	var randomItem: OfficeItem = GetRandomItemBasedOnPlayer(isPlayer)
	randomItem.ReceiveEffect(Enums.EFFECT.HASTE, duration)

func OnItemFreezeUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	# inverse to get other items
	var randomItem: OfficeItem = GetRandomItemBasedOnPlayer(!isPlayer)
	randomItem.ReceiveEffect(Enums.EFFECT.FREEZE, duration)
	
func OnItemChargeUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	var randomItem: OfficeItem = GetRandomItemBasedOnPlayer(isPlayer)
	randomItem.ReceiveEffect(Enums.EFFECT.CHARGE, duration)

func PlayerAmountItems():
	return player_office_items.size()

func DeleteShopItem(officeItem: OfficeItem):
	shop_office_items.erase(officeItem)

func DeletePlayerItem(officeItem: OfficeItem):
	player_office_items.erase(officeItem)
	officeItem.queue_free()

func AddPlayerItem(officeItem: OfficeItem):
	player_office_items.push_back(officeItem)

func GetRandomItemBasedOnPlayer(isPlayer: bool):
	var randomItem: OfficeItem = null
	if isPlayer:
		randomItem = GetRandomItemFromItemList(player_office_items)
	else:
		randomItem = GetRandomItemFromItemList(enemy_office_items)
	return randomItem

func GetRandomItemFromItemList(current_list: Array[OfficeItem]):
	return current_list[rng.randi_range(0, current_list.size()-1 )]
