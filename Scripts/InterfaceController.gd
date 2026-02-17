class_name InterfaceController
extends Node3D

@onready var enemy_health: Label = $EnemyHealthLabel
@onready var enemy_health_progress_bar: TextureProgressBar = $EnemyHealthProgressBar
@onready var player_health: Label = $PlayerHealthLabel
@onready var player_health_progress_bar: TextureProgressBar = $PlayerHealthProgressBar

func DisplayEnemyHealth():
	enemy_health.text = "Health: " + str(Global.enemy_health)
	enemy_health_progress_bar.value = Global.enemy_health / Global.enemy_max_health
	pass

func DisplayPlayerHealth():
	player_health.text = "Health: " + str(Global.player_health)
	player_health_progress_bar.value = Global.player_health / Global.player_max_health
