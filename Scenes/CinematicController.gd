extends Node3D

@onready var camera: Camera3D = %MainCamera3D
@onready var interface: InterfaceController = %Interface

@export var cameraGameplayPosition: Vector3
@export var cameraGameplayRotation: Vector3

@export var cameraCinematicPosition: Vector3
@export var cameraCinematicRotation: Vector3

@export var cameraCinematicTIPosition: Vector3
@export var cameraCinematicTIRotation: Vector3

@export var cameraCinematicSecurityPosition: Vector3
@export var cameraCinematicSecurityRotation: Vector3

@export var cameraCinematicBossPosition: Vector3
@export var cameraCinematicBossRotation: Vector3

var currentCameraPosition: Vector3
var currentCameraRotation: Vector3

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
	GrabCameraPositionBasedOnCinematic()
	if isGameplay:
		camera.position = cameraGameplayPosition
		camera.rotation = cameraGameplayRotation
	else:
		camera.position = currentCameraPosition
		camera.rotation = currentCameraRotation
	# camera

func GrabCameraPositionBasedOnCinematic():
	match Global.cinematic_state:
		Global.CINEMATIC_STATE.INITIAL:
			currentCameraPosition = cameraCinematicPosition
			currentCameraRotation = cameraCinematicRotation
		Global.CINEMATIC_STATE.IT:
			currentCameraPosition = cameraCinematicTIPosition
			currentCameraRotation = cameraCinematicTIRotation
		Global.CINEMATIC_STATE.SECURITY:
			currentCameraPosition = cameraCinematicSecurityPosition
			currentCameraRotation = cameraCinematicSecurityRotation
		Global.CINEMATIC_STATE.BOSS:
			currentCameraPosition = cameraCinematicBossPosition
			currentCameraRotation = cameraCinematicBossRotation
