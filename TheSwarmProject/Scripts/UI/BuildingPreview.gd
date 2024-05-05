extends Sprite2D
class_name BuildingPreview

@export var buildingResource : StructureResource = load("res://Resources/Structures/WoodenTower.tres")
@onready var tilemap : TileMap = get_tree().get_first_node_in_group('TileMap')
@onready var collisionShape2D = $Area2D/CollisionShape2D

var isActive : bool = false

func _physics_process(_delta):
	if !isActive:
		return
	global_position = tilemap.map_to_local(tilemap.local_to_map(get_tree().current_scene.get_global_mouse_position()))
	if ! CheckCollision() and buildingResource.costResource.CheckCost():
		modulate = Color(Color.GREEN, 100)
	else:
		modulate = Color(Color.RED, 100)

func PlaceBuilding() -> bool:
	var positionToLocal = tilemap.local_to_map(global_position)
	if ! buildingResource.costResource.SpendResources():
		print_debug('Insufficient Parts')
		return false
	if CheckCollision():
	#Creation.CheckStructureCollision(tilemap.local_to_map(global_position),buildingResource.cellCollisions)
	#if !Creation.CheckStructureCollision(tilemap.local_to_map(global_position),
	# buildingResource.cellCollisions):
		print_debug('TileOccupied')
		return false
	Creation.BuildStructure(global_position, buildingResource)
	return true

func SetActive(boolean : bool = true):
	if boolean:
		isActive = true
		texture = buildingResource.visuals
		collisionShape2D.shape.size = buildingResource.buildingSize
	else:
		isActive = false
		modulate.a = 0
		
func CheckCollision() -> bool:
	return $Area2D.has_overlapping_bodies()
		
