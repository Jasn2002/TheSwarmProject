extends CharacterBody2D
class_name Unit

@onready var sprite = $Sprite2D

@export var resource : UnitResource

@export var speed : float = 200

@export var navigationComponent : NavigationComponent
@export var targetAcquisitionComponent : TargetAcquisitionComponent
@export var healthComponent : HealthComponent
@export var damageComponent : DamageComponent

var attackSpeed : float = 0.5
var isAttacking : bool = false
var currentState : STATES = STATES.IDLE
var currentTarget : Node2D = null

enum STATES {
	IDLE,
	MOVING,
	ATTACK
}

func _ready():
	if !healthComponent:
		healthComponent = load('res://Scenes/Components/HealthComponent.tscn').instantiate()
		self.add_child(healthComponent)
	healthComponent.hitpointsZero.connect(Die)
	#healthComponent.onCreation(resource)
	ckeckDefaultComponent(targetAcquisitionComponent, TargetAcquisitionComponent)
	targetAcquisitionComponent.Init()
	ckeckDefaultComponent(navigationComponent, NavigationComponent)
	ckeckDefaultComponent(damageComponent, DamageComponent)
		
func ckeckDefaultComponent(componentVariable, componentType) -> void:
	if !componentVariable:
		componentVariable = componentType.new()
		add_child(componentVariable)
	


func _physics_process(_delta):
	ProcessState()
	

func ProcessState() -> void:
	match currentState:
		STATES.IDLE:
			if targetAcquisitionComponent.targetsInRange:
				currentState = STATES.ATTACK
				return
			if self.velocity != Vector2.ZERO:
				currentState = STATES.MOVING
				return
			Animate('idle')
		STATES.MOVING:
			if targetAcquisitionComponent.targetsInRange:
				currentState = STATES.ATTACK
				return
			if navigationComponent.target_position.x < self.global_position.x:
				sprite.scale.x = -1
			else:
				sprite.scale.x = 1
			if self.velocity.is_zero_approx():# == Vector2.ZERO:
				currentState = STATES.IDLE
				return
			Animate('running')
		STATES.ATTACK:
			if !targetAcquisitionComponent.targetsInRange:
				currentState = STATES.IDLE
				return
			currentTarget = targetAcquisitionComponent.acquireTarget()
			if !is_instance_valid(currentTarget):
				currentTarget = null
				currentState = STATES.IDLE
				return
			if global_position.distance_to(currentTarget.global_position) \
					> targetAcquisitionComponent.detectionRange:
				navigationComponent.MoveTo(currentTarget.global_position)
				if currentTarget.global_position.x < self.global_position.x:
					sprite.scale.x = -1
				else:
					sprite.scale.x = 1
				return
			else:
				Attack()
		_:
			return


func Animate(animationName : String) -> void:
	if isAttacking and animationName != 'attacking':
		return
	sprite.play(animationName)
	
		
func Attack():
	if !currentTarget:
		isAttacking = false
		return
	if !is_instance_valid(currentTarget):
		isAttacking = false
		currentTarget = null
		currentState = STATES.IDLE
		return
	if sprite.is_playing() and sprite.animation == 'attacking':
		#print_debug('ATTACK started')
		await sprite.animation_finished
		print_debug('actual ATTACK')
		if !currentTarget:
			return
		if !is_instance_valid(currentTarget):
			return
		currentTarget.healthComponent.TakeDamage(damageComponent.baseDamage, damageComponent.damageType)
		isAttacking = false
		currentTarget = null
		currentState = STATES.IDLE
	else:
		print_debug('ATTACK  animation')
		Animate('attacking')
		isAttacking = true
		return
	
	
	

func Die () -> void :
	self.remove_from_group('Ally')
	Creation.createEnemyDeath(self.global_position)
	queue_free()


