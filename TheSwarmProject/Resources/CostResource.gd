extends Resource
class_name CostResource

@export var cost : int = 0
@export var resourceType : GameManager.RESOURCE_ID = GameManager.RESOURCE_ID.PARTS

func CheckCost() -> bool:
	if GameManager.GetResourceValue(resourceType) < cost:
		return false
	return true
	
func SpendResources() -> bool:
	if CheckCost():
		GameManager.ModifyResource(resourceType, - cost)
		return true
	return false
