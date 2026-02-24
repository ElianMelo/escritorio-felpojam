class_name EnemyData
extends Resource

@export var name: String
@export var title: String
@export var subTitle: String
@export var cine_state: Global.CINEMATIC_STATE
@export var health: int
@export var enemyItems: Array[OfficeItemData]

func _init(p_name: String = "", \
	p_title: String = "", \
	p_subTitle: String = "", \
	p_cine_state: Global.CINEMATIC_STATE = Global.CINEMATIC_STATE.INITIAL, \
	p_health: int = 0, \
	p_enemyItems: Array[OfficeItemData] = []):
	name = p_name
	title = p_title
	subTitle = p_subTitle
	cine_state = p_cine_state
	health = p_health
	enemyItems = p_enemyItems
	
