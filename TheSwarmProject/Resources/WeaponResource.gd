extends Resource
class_name WeaponResource

@export var name : String = 'Weapon'
@export var visuals : CompressedTexture2D = preload('res://Images/Weapon/TurretWoodenBallista.png')
@export var reloadTime : float = 0.5 # in seconds
@export var detectionRange : float = 200 # radius
@export var costResource : CostResource = preload("res://Resources/DefaultCost.tres")
