extends Node3D

@onready var camera: Camera3D = %MainCamera3D

@export var cameraGameplayPosition: Vector3
@export var cameraGameplayRotation: Vector3

@export var cameraCinematicPosition: Vector3
@export var cameraCinematicRotation: Vector3

var isGameplay:bool = true

func _ready() -> void:
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

func OnGameStateChanged(state: Global.GAME_STATE):
	match state:
		Global.GAME_STATE.CINEMATIC:
			SwitchCamera(true)
		_:
			SwitchCamera(false)

func SwitchCamera(isCurrentGameplay: bool):
	isGameplay = !isCurrentGameplay
	if isGameplay:
		camera.position = cameraGameplayPosition
		camera.rotation = cameraGameplayRotation
	else:
		camera.position = cameraCinematicPosition
		camera.rotation = cameraCinematicRotation
	# camera
