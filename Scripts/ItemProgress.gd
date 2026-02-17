class_name ItemProgress
extends Sprite3D

@onready var progress_bar: TextureProgressBar = $SubViewport/TextureProgressBar
@onready var progress_sprite: Sprite3D = $"."

var currentEffect: Enums.EFFECT = Enums.EFFECT.HASTE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_current_mode(effect: Enums.EFFECT):
	currentEffect = effect
	match currentEffect:
		Enums.EFFECT.HASTE:
			progress_sprite.modulate = Color.AQUAMARINE
		Enums.EFFECT.FREEZE:
			progress_sprite.modulate = Color.CYAN
		Enums.EFFECT.SLOW:
			progress_sprite.modulate = Color.YELLOW
		Enums.EFFECT.CHARGE:
			progress_sprite.modulate = Color.ORCHID
		Enums.EFFECT.NONE:
			progress_sprite.modulate = Color.WHITE
	pass
	
func set_current_progress(percentage: float):
	progress_bar.value = percentage
