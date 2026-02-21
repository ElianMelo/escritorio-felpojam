class_name OfficeItem
extends RigidBody3D

@export var office_item_data: OfficeItemData = null
@export var camera: Camera3D
@onready var office_item_usage: OfficeItemUsage = $OfficeItemUsage
@onready var item_progress: ItemProgress = $ItemProgress
@export var listDecal: Array[Decal] = []

var spawner_controller: SpawnerController

var isDragging: bool = false
var isPlayer: bool = true
var isShop: bool = false
const RotateSpeed: float = 20

var currentDecalIndex: int = 0
var stamp: bool = false
var stampList: Array[StampEffectData] = []
var currentStampEffectSearch: Enums.STAMP_EFFECT

signal item_damage_used(damage: int, isPlayer: bool)
signal item_slow_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_freeze_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_haste_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_charge_used(duration: float, target: Enums.EFFECT_TARGET, isPlayer: bool)
signal item_mouse_entered(officeItem: OfficeItem)
signal item_mouse_exited()

func SetupData(cameraSetup: Camera3D, officeItemData: OfficeItemData,
	spawnerController: SpawnerController,
	isThisPlayer: bool,
	isThisShop: bool = false):
	isPlayer = isThisPlayer
	isShop = isThisShop
	spawner_controller = spawnerController
	camera = cameraSetup
	office_item_data = officeItemData
	office_item_usage.SetDuration(office_item_data.reload)
	SpawnMesh()

func SpawnMesh():
	var instace = office_item_data.meshScene.instantiate()
	var meshMode = instace as Node3D
	add_child(instace)
	meshMode.rotation_degrees = Vector3(0,90,0)
	meshMode.position += Vector3(0,0.2,0)
	meshMode.position += Vector3(0,office_item_data.meshYOffset,0)

func SetDecal(texture: Texture2D):
	if currentDecalIndex >= listDecal.size(): return
	listDecal[currentDecalIndex].texture_albedo = texture
	listDecal[currentDecalIndex].texture_emission = texture
	listDecal[currentDecalIndex].visible = true
	currentDecalIndex += 1

func ReceiveEffect(effect: Enums.EFFECT, duration: float):
	office_item_usage.ReceiveEffect(effect, duration)
	spawner_controller.SpawnPopup(self.position + \
		Vector3(0,1,0), effect)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	office_item_usage.SetDuration(office_item_data.reload)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
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

func AddStampEffect(stampEffect: Enums.STAMP_EFFECT, stampValue: float):
	stamp = true
	stampList.push_back(StampEffectData.new(stampEffect, stampValue))
	pass

func GetFinalValueOnStamps(stampEffect: Enums.STAMP_EFFECT):
	if stampList.size() == 0: return 0
	var finalResult = 0
	for i in range(0, stampList.size()):
		if stampList[i].stampEffect == stampEffect:
			finalResult += stampList[i].stampEffectValue
	return finalResult

func use_item():
	if office_item_data.canDamage or \
	 	GetFinalValueOnStamps(Enums.STAMP_EFFECT.DAMAGE) != 0:
		emit_signal("item_damage_used", office_item_data.damage \
		+ GetFinalValueOnStamps(Enums.STAMP_EFFECT.DAMAGE), isPlayer)
	if office_item_data.canFreeze or \
	 	GetFinalValueOnStamps(Enums.STAMP_EFFECT.FREEZE) != 0:
		emit_signal("item_freeze_used", office_item_data.freezeDuration + GetFinalValueOnStamps(Enums.STAMP_EFFECT.FREEZE),
			office_item_data.effectTarget, isPlayer)
	if office_item_data.canHaste or \
	 	GetFinalValueOnStamps(Enums.STAMP_EFFECT.HASTE) != 0:
		emit_signal("item_haste_used", office_item_data.hasteDuration + GetFinalValueOnStamps(Enums.STAMP_EFFECT.HASTE),
			office_item_data.effectTarget, isPlayer)
	if office_item_data.canSlow or \
	 	GetFinalValueOnStamps(Enums.STAMP_EFFECT.SLOW) != 0:
		emit_signal("item_slow_used", office_item_data.slowDuration + GetFinalValueOnStamps(Enums.STAMP_EFFECT.SLOW),
			office_item_data.effectTarget, isPlayer)
	if office_item_data.canCharge or \
	 	GetFinalValueOnStamps(Enums.STAMP_EFFECT.CHARGE) != 0:
		emit_signal("item_charge_used", office_item_data.chargeSeconds + GetFinalValueOnStamps(Enums.STAMP_EFFECT.CHARGE),
			office_item_data.effectTarget, isPlayer)
	use_item_tween()

func use_item_tween():
	@warning_ignore("unused_variable")
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
	if Input.is_action_just_pressed("g_key_button"):
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
@warning_ignore("unused_parameter")
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


func _on_mouse_entered() -> void:
	emit_signal("item_mouse_entered", self)


func _on_mouse_exited() -> void:
	emit_signal("item_mouse_exited")
