extends Button
class_name ConstructionButton

@export var structureResource : StructureResource = load("res://Resources/Structures/WoodenTower.tres")
	
func assign():
	InputManager.buildCommandSelected(structureResource)
	
func _ready():
	self.button_up.connect(assign)
