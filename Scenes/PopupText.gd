
class_name PopupText
extends Label3D

var rng = RandomNumberGenerator.new()
var tweenDuration: float = 1

var currentEffect: Enums.EFFECT

func _ready() -> void:
	pass

func SetupPopupData(text: String, effect: Enums.EFFECT):
	self.text = text
	currentEffect = effect
	DestroyCoroutine()

func DestroyCoroutine():
	self.offset = Vector2(
		rng.randi_range(-40, 40),
		rng.randi_range(-40, 40))
	self.font_size = rng.randi_range(58, 64)
	var color = Global.GetColorByEffect(currentEffect)
	self.modulate = color
	color.a = 0
	var tweenOne = create_tween()
	tweenOne.tween_property(self, "offset", Vector2(0, 100), tweenDuration)
	var tweenTwo = create_tween()
	tweenTwo.tween_property(self, "modulate", color, tweenDuration)
	var tweenThree = create_tween()
	tweenThree.tween_property(self, "outline_size", 0, tweenDuration)
	await get_tree().create_timer(tweenDuration).timeout
	self.queue_free()
