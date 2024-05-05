extends Resource
class_name StructureResource

@export var name : String = 'Tower'
@export var visuals : CompressedTexture2D = preload("res://Images/Structures/TurretWoodenBase.png")
@export var weaponSlots : int = 1
@export var costResource : CostResource = preload("res://Resources/DefaultCost.tres")
@export var buildingSize : Vector2i = Vector2i(32, 32)
