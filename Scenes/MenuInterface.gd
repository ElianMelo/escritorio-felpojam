class_name MenuInterface
extends Control

var isEnabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Switch():
	isEnabled = !isEnabled
	if isEnabled:
		ShowVisuals()
	else:
		HideVisuals()

func ShowVisuals():
	self.visible = true
	Engine.time_scale = 0
	Global.isGamePaused = true
	pass

func HideVisuals():
	Engine.time_scale = 1
	Global.isGamePaused = false
	self.visible = false
	pass

func _on_resume_button_pressed() -> void:
	HideVisuals()

func _on_play_button_pressed() -> void:
	HideVisuals()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
