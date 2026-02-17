class_name OfficeItem
extends RigidBody3D

@export var office_item_data: OfficeItemData = null
@export var camera: Camera3D
@onready var office_item_usage: OfficeItemUsage = $OfficeItemUsage
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var item_progress: ItemProgress = $ItemProgress

var isDragging: bool = false
var isPlayer: bool = true
const RotateSpeed: float = 20

signal item_damage_used(damage: int, isPlayer: bool)
signal item_slow_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_freeze_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_haste_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)

func SetupData(cameraSetup: Camera3D, officeItemData: OfficeItemData,
	isThisPlayer: bool):
	isPlayer = isThisPlayer
	camera = cameraSetup
	office_item_data = officeItemData
	office_item_usage.SetDuration(office_item_data.reload)
	mesh_instance_3d.mesh = office_item_data.meshResource

func ReceiveEffect(effect: Enums.EFFECT, duration: float):
	office_item_usage.ReceiveEffect(effect, duration)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	office_item_usage.SetDuration(office_item_data.reload)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	item_progress.visible = Global.game_state == Global.GAME_STATE.BATTLE
	pass

func _physics_process(delta: float) -> void:
	if !isDragging: return
	handle_object_position()
	handle_object_rotation(delta)
	handle_object_reset()
	handle_scale_test()

func start_drag():
	isDragging = true

func stop_drag():
	isDragging = false

func use_item():
	if office_item_data.canDamage:
		emit_signal("item_damage_used", office_item_data.damage, isPlayer)
	if office_item_data.canFreeze:
		emit_signal("item_freeze_used", office_item_data.freezeDuration,
			office_item_data.effectTarget, isPlayer)
	if office_item_data.canHaste:
		emit_signal("item_haste_used", office_item_data.hasteDuration,
			office_item_data.effectTarget, isPlayer)
	if office_item_data.canSlow:
		emit_signal("item_slow_used", office_item_data.slowDuration,
			office_item_data.effectTarget, isPlayer)
	use_item_tween()

func use_item_tween():
	var startY = position.y
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.2, 1, 1.2), 0.2)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
		
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

func handle_scale_test():
	if Input.is_action_just_pressed("button_test"):
		check_overlap(3)
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3(1.2, 1.2, 1.2), 0.2)
		tween.tween_property(self, "rotation", Vector3(rotation.x, rotation.y + 5, rotation.z), 0.5)
		tween.tween_property(self, "scale", Vector3.ONE, 0.2)
	pass

func handle_move_forward(speed:float, delta:float):
	# according to world
	# -transform.basis.z local
	# -global_transform.basis.z
	global_position += -global_transform.basis.z * speed * delta
	pass

# check overlap with collision shape 3d down
func check_overlap(offsetValue:float):
	var space_state = get_world_3d().direct_space_state
	var box := BoxShape3D.new()
	# detect range
	box.size = Vector3(0.3, 3, 0.3)
	
	#detect left item
	var offset = Vector3(-0.5, 0, 0)
	
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = box
	query.transform = Transform3D(Basis(), global_position + offset)
	query.exclude = [self]
	query.collide_with_bodies = true
	query.collide_with_areas = false
	# layer 2 - only objects
	query.collision_mask = 2
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		print("Hit:", result.collider.name)
