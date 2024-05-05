extends Node2D
class_name TargetAcquisitionComponent

var targetsInRange : Array[CharacterBody2D] = []
@export var detectionRange : float = 200
@export var targetGroupName : String = 'Enemy'

func Init() -> void:
	var detectionComponent : DetectionComponent = load('res://Scenes/Components/DetectionComponent.tscn').instantiate()
	add_child(detectionComponent)
	detectionComponent.detectionRange = self.detectionRange
	detectionComponent.Init()

func acquireTarget() -> CharacterBody2D:
	cleanList()
	if !targetsInRange:
		return null
	var new_target = targetsInRange.pick_random()
	return new_target if is_instance_valid(new_target) else null
	
func cleanList():
	var i = 0
	for target in targetsInRange:
		if !is_instance_valid(targetsInRange[i]):
			targetsInRange.remove_at(i)
		i+=1


func on_body_entered (body : CharacterBody2D) :
	if !body:
		return
	if !body.is_in_group(targetGroupName):
		return
	targetsInRange.append(body)
	
func on_body_exited(body : CharacterBody2D) :
	if !body:
		return
	if !body.is_in_group(targetGroupName):
		return
	if targetsInRange.has(body) :
		targetsInRange.erase(body)
