extends Node

@onready var tilemap : TileMap = get_tree().get_first_node_in_group('TileMap')

func createStructure(position : Vector2 ,resource : StructureResource, weaponList : Array[Weapon] = []) -> Structre:
	var newStructure = null
	var tilemap : TileMap = get_tree().get_first_node_in_group('TileMap')
	#BOTH calculations are necessary for the sprite to be properly centered on the tile
	var positionToLocal = tilemap.local_to_map(position)
	if tilemap.get_cell_tile_data(0, positionToLocal) == null:
		#tilemap.set_cell(0, positionToLocal, 2, Vector2i(0, 0))
		#tilemap.get_parent().bake_navigation_polygon()
		newStructure = load("res://Scenes/Templates/Structure.tscn").instantiate()
		get_tree().current_scene.add_child(newStructure)
		newStructure.global_position = tilemap.map_to_local(positionToLocal)
		newStructure.onCreation(resource, weaponList)
	else:
		print_debug('TILE OCCUPIED')
	#tilemap.get_parent().bake_navigation_polygon()
	return newStructure
	
func createWeapon(resource : WeaponResource, ProjectileList : Array[ProjectileResource] = []) -> Weapon:
	var newWeapon = load('res://Scenes/Templates/Weapon.tscn').instantiate()
	newWeapon.onCreation(resource, ProjectileList)
	
	return newWeapon
	
func createProjectile(resource : ProjectileResource) -> Projectile:
	var newProjectile = load('res://Scenes/Templates/Projectile.tscn').instantiate()
	newProjectile.onCreation(resource)
	
	return newProjectile

func createEnemy(resource : EnemyResource) -> Enemy:
	var new_enemy = load('res://Scenes/Units/Enemies/Enemy.tscn').instantiate()
	new_enemy.onCreation(resource)
	
	return new_enemy
	
func createEnemyDeath(position : Vector2):
	var newDeathAnimation = load("res://Scenes/Units/Enemies/EnemyDeath.tscn").instantiate()
	get_tree().root.add_child(newDeathAnimation)
	newDeathAnimation.global_position = position
	
func createEnemyWave(availableEnemies : Array[EnemyResource], waveTotalStrenght : int) -> Array[Enemy]:
	var currentWaveStrenght = 0
	var newEnemyArray : Array[Enemy]
	var attemptsMade : int = 0
	while currentWaveStrenght < waveTotalStrenght && attemptsMade < 100:
		attemptsMade += 1
		var candidate : EnemyResource = availableEnemies.pick_random()
		if candidate.threatValue < (waveTotalStrenght-currentWaveStrenght):
			newEnemyArray.append(createEnemy(candidate))
			currentWaveStrenght += candidate.threatValue
	return newEnemyArray

func BuildStructure(position : Vector2, 
 resource : StructureResource) -> void:
	var newStructure = null
	#BOTH calculations are necessary for the sprite to be properly centered on the tile
	var positionToLocal = tilemap.local_to_map(position)
	tilemap.erase_cell(0, positionToLocal)
	newStructure = load("res://Scenes/Templates/Structure.tscn").instantiate()
	get_tree().current_scene.add_child(newStructure)
	#tilemap.get_parent().call_deferred('bake_navigation_polygon')
	newStructure.global_position = tilemap.map_to_local(positionToLocal)
	newStructure.OnBuild(resource)
