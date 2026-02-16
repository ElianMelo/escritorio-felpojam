extends Node3D

@onready var office_item: OfficeItem = $"../../OfficeItem"
@onready var interface: InterfaceController = %Interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	office_item.connect("item_damage_used", OnItemDamageUsed)
	office_item.connect("item_slow_used", OnItemSlowUsed)
	office_item.connect("item_haste_used", OnItemHasteUsed)
	office_item.connect("item_freeze_used", OnItemFreezeUsed)
	pass # Replace with function body.

func OnItemDamageUsed(damage: int):
	Global.enemy_health -= damage
	if Global.enemy_health <= 0:
		Global.enemy_health = 0
	interface.DisplayEnemyHealth()
	pass

func OnItemSlowUsed(duration: float, target: Enums.EFFECT_TARGET):
	print("Slow!!!")
	pass

func OnItemHasteUsed(duration: float, target: Enums.EFFECT_TARGET):
	print("Haste!!!")
	pass

func OnItemFreezeUsed(duration: float, target: Enums.EFFECT_TARGET):
	print("Freeze!!!")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
