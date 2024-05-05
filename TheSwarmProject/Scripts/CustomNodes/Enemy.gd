extends CharacterBody2D
class_name Enemy

@export var id : String = '020';
@export var speed : float = 100;

@export var resource : EnemyResource
@export var navigationComponent : NavigationComponent

@export var healthComponent : HealthComponent

func _ready():
	if !healthComponent:
		healthComponent = load('res://Scenes/Components/HealthComponent.tscn').instantiate()
		self.add_child(healthComponent)
	healthComponent.hitpointsZero.connect(Die)
	healthComponent.onCreation(resource)
	ckeckDefaultComponent(navigationComponent, NavigationComponent)
		
func ckeckDefaultComponent(componentVariable, componentType) -> void:
	if !componentVariable:
		componentVariable = componentType.new()
		add_child(componentVariable)
	
func onCreation(_resource : EnemyResource):
	self.resource = _resource
	self.id = _resource.id
	self.speed = _resource.speed
	self.name = _resource.name
		
func Die () -> void :
	self.remove_from_group('Enemy')
	print_debug('die')
	Creation.createEnemyDeath(self.global_position)
	queue_free()


