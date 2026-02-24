extends SubViewportContainer

@onready var animation_player: AnimationPlayer = $"SubViewport/Caderno opções in game/AnimationPlayer"
@onready var _osso_capa: Node3D = $"SubViewport/Caderno opções in game/ osso capa"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key_button"):
		_osso_capa.visible = true
		animation_player.play("Capa indo")
	if Input.is_action_just_pressed("s_key_button"):
		_osso_capa.visible = false
		animation_player.play("Pag Indo")
	pass
