extends Area2D
class_name HurtboxComponent

signal GotHit (hitbox : HitboxComponent)

@export var healthComponent : HealthComponent

func _init():
	if ! healthComponent:
		healthComponent = load("res://Scenes/Components/HealthComponent.tscn").instantiate()
		add_sibling(healthComponent)
		
	self.collision_layer = 0
	self.collision_mask = 2
	self.area_entered.connect(OnAreaEntered)
	self.monitorable = false
	
func OnAreaEntered (hitbox : HitboxComponent) -> void:
	if ! hitbox :
		return
	GotHit.emit(hitbox)
	hitbox.HitArea.emit(self)
	healthComponent.TakeDamage(hitbox.damageComponent.baseDamage, hitbox.damageComponent.damageType)
