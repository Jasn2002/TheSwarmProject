extends Area2D
class_name HitboxComponent

signal HitArea (hurtbox : HurtboxComponent)

@export var damageComponent : DamageComponent

func _init():
	
	if ! damageComponent:
		damageComponent = DamageComponent.new()
		add_child(damageComponent)
		
	self.collision_layer = 2
	self.collision_mask = 0
	self.monitoring = false
