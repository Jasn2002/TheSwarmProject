extends CharacterBody2D
class_name Projectile

@onready var expirationTimer : Timer = $ExpirationTimer

@export var resource : ProjectileResource
@export var damage : float = 2.5
@export var speed : float = 100
@export var expirationTime : float = 3  # in seconds

var currentTarget : CharacterBody2D

func _ready():
	expirationTimer.timeout.connect(queue_free)
	$HitboxComponent.HitArea.connect(func (_hurtbox) : $HitboxComponent.queue_free())

func onCreation (_resource : ProjectileResource) -> void:
	if !_resource:
		return
	self.resource = _resource
	self.name = _resource.name
	$Sprite.texture = _resource.visuals
	self.damage = _resource.damage
	self.speed = _resource.speed
	self.expirationTime = _resource.expirationTime
	
func Fly (target : CharacterBody2D) -> void :
	expirationTimer.start(expirationTime)
	var predictedPoint = predictPoint(target)
	look_at(predictedPoint)
#	velocity = global_position.direction_to((target.global_position + (target.velocity))) * speed
	velocity = global_position.direction_to(predictedPoint) * speed
	$SFXPlayer.play()
	
func _physics_process(_delta):
	if velocity == Vector2.ZERO:
		return
	move_and_slide()
	
func predictPoint(target : CharacterBody2D) -> Vector2:
	var projectileTime = self.global_position.distance_to(target.global_position) / self.speed
	var predictedPoint : Vector2 = target.global_position + (target.velocity * projectileTime)
#	var predictedPoint : Vector2 = (projectileTime * target.speed)
	return predictedPoint
	
	
	
	
