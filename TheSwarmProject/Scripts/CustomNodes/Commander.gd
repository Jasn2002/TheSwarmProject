extends Unit
class_name Commander

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
	
