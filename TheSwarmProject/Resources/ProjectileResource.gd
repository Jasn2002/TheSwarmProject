extends Resource
class_name ProjectileResource

@export var name : String = 'Projectile'
@export var visuals : CompressedTexture2D = preload('res://Images/Projectile/ProjectileArrow.png')
@export var damage : float = 1
@export var speed : float = 500
@export var expirationTime : float = 2.5
