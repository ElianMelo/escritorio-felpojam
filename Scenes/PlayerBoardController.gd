extends Node3D

@onready var office_item: OfficeItem = $"../../OfficeItem"
@onready var interface: InterfaceController = %Interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	office_item.connect("item_used", OnItemUsed)
	pass # Replace with function body.

func OnItemUsed(damage: int):
	Global.enemy_health -= 10
	interface.DisplayEnemyHealth()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
