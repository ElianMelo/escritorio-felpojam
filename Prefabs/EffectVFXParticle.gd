class_name EffectVFXParticle
extends CPUParticles3D

@onready var effect_vfx_particle: CPUParticles3D = $"."

func SetupEffectVFX(newMat: Material):
	effect_vfx_particle.material_override = newMat
	effect_vfx_particle.emitting = true
	await get_tree().create_timer(0.7).timeout
	self.queue_free()
