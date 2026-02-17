extends Node3D

@onready var office_item: OfficeItem = $"../../OfficeItem"
@onready var interface: InterfaceController = %Interface
@onready var camera: Camera3D = %MainCamera3D
@export var office_item_data: Array[OfficeItemData]

var office_item_list: Array[OfficeItem]

var rng = RandomNumberGenerator.new()

const OFFICE_ITEM = preload("res://Prefabs/OfficeItem.tscn")

var currentXOffset = -2
var currentZOffset = 2
var offsetIncrease = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 2):
		InstantiateOfficeItem(true)
		currentXOffset += offsetIncrease
	currentXOffset = -2
	currentZOffset = -2
	for i in range(0, 4):
		InstantiateOfficeItem(false)
		currentXOffset += offsetIncrease
	#office_item_list.push_back(office_item)
	#SetupOfficeItem(office_item)
	#OrderArrayBasedOnPosition()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("r_key_button"):
		InstantiateOfficeItem(true)
		pass
	pass

func OrderArrayBasedOnPosition():
	office_item_list.sort_custom(func(a, b): return a.position.x[1] > b.position.x[1])

func InstantiateOfficeItem(isPlayer: bool):
	var instace = OFFICE_ITEM.instantiate()
	add_child(instace)
	var officeItem = instace as OfficeItem
	if officeItem == null: return
	officeItem.position += Vector3(currentXOffset, 0, currentZOffset)
	officeItem.ResetRotation()
	officeItem.SetupData(camera, 
		office_item_data[rng.randi_range(0, office_item_data.size()-1 )], 
		isPlayer)
	SetupOfficeItem(officeItem)
	OrderArrayBasedOnPosition()

func SetupOfficeItem(currentOfficeItem: OfficeItem):
	currentOfficeItem.connect("item_damage_used", OnItemDamageUsed)
	currentOfficeItem.connect("item_slow_used", OnItemSlowUsed)
	currentOfficeItem.connect("item_haste_used", OnItemHasteUsed)
	currentOfficeItem.connect("item_freeze_used", OnItemFreezeUsed)

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
	print("Slow!!!")
	pass

func OnItemHasteUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	print("Haste!!!")
	pass

func OnItemFreezeUsed(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool):
	print("Freeze!!!")
	pass
