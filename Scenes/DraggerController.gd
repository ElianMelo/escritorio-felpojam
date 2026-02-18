extends Node3D

const RAY_LENGTH = 10000.0
@onready var cam: Camera3D = %MainCamera3D

var currentOfficeItem: OfficeItem = null
var isDragging: bool = false

func _physics_process(delta):
	if Global.game_state == Global.GAME_STATE.BATTLE: return
	if Input.is_action_just_released("left_click"):
		if isDragging:
			handle_stop_drag()
			return
	if Input.is_action_just_pressed("left_click"):
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if result == null: return
		var collision_object = result.collider
		handle_start_drag(collision_object)

func handle_start_drag(baseObject):
	var officeItem = baseObject as OfficeItem
	if officeItem == null: return
	currentOfficeItem = officeItem
	#if !currentOfficeItem.isPlayer: return
	if !currentOfficeItem.isShop && \
		 !currentOfficeItem.isPlayer: return
	currentOfficeItem.start_drag()
	isDragging = true

func handle_stop_drag():
	if !isDragging: return
	currentOfficeItem.stop_drag()
	currentOfficeItem = null
	isDragging = false
