class_name InterfaceController
extends Node3D

@onready var enemy_health: Label = $EnemyHealthLabel
@onready var enemy_health_progress_bar: TextureProgressBar = $EnemyHealthProgressBar

func DisplayEnemyHealth():
	enemy_health.text = "Health: " + str(Global.enemy_health)
	enemy_health_progress_bar.value = Global.enemy_health / Global.enemy_max_health
	pass
