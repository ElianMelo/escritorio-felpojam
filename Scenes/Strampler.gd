class_name Strampler
extends RigidBody3D

@onready var camera: Camera3D = %MainCamera3D
@onready var animation_player: AnimationPlayer = $CarimboVisuals/AnimationPlayer


var isDragging: bool = false
const RotateSpeed: float = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !isDragging: return
	handle_object_position()
	handle_object_rotation(delta)
	handle_object_reset()

func start_drag():
	isDragging = true

func stop_drag():
	isDragging = false

func handle_object_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, 1)
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	if intersection:
		position = intersection

func handle_object_rotation(delta):
	if Input.is_action_just_pressed("scroll_up"):
		rotate_y(RotateSpeed * delta * 1)
	if Input.is_action_just_pressed("scroll_down"):
		rotate_y(RotateSpeed * delta * -1)
	pass

func handle_object_reset():
	if Input.is_action_just_pressed("right_click"):
		rotation = Vector3(-45, 0, 0)
		ResetRotation()
	pass

func ResetRotation():
	rotation = Vector3(0, 0, 0)

func PlayAnimation():
	animation_player.play("Action_001", -1, 3)
