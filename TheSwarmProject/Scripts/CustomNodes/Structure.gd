extends Node2D
class_name Structre

@onready var weaponHolder : Node2D

@export var resource : StructureResource
@export var id : String = '010';
@export var buildingCollisionComponent : StaticBody2D
#WEAPON Variables
@export var weaponsMounted : Array[Weapon] = []

func onCreation (_resource : StructureResource, weaponsList : Array[Weapon]) -> void:
	OnBuild(_resource)
	for weapon in weaponsList:
		weaponsMounted.append(weapon)
		weaponHolder.add_child(weapon)
		
func OnBuild(_resource : StructureResource):
	if !_resource:
		return
	self.resource = _resource
	self.name = _resource.name
	$Sprite.texture = _resource.visuals
	weaponHolder = $WeaponHolder
	print_debug(buildingCollisionComponent)
	buildingCollisionComponent = load('res://Scenes/Components/BuildingCollisionComponent.tscn').instantiate()
	add_child(buildingCollisionComponent)
	buildingCollisionComponent.get_child(0).shape.size = resource.buildingSize - Vector2i(20, 20)

func OnSelection():
	print_debug('SELECTED: ', self.name)

func OnDeSelection():
	print_debug('DESELECTED: ', self.name)
