class_name EnemyData
extends Resource

@export var name: String
@export var health: int
@export var enemyItems: Array[OfficeItemData]

func _init(p_name: String = "", \
	p_health: int = 0, \
	p_enemyItems: Array[OfficeItemData] = []):
	name = p_name
	health = p_health
	enemyItems = p_enemyItems
	
