extends Node2D

var healthPoints : int = 10

@export var camera : Camera2D
@export var tilemap : TileMap

func _ready():
	
	$MainGUI.UpdateResources()
	
	Creation.createStructure(\
	Vector2(416, 243),\
	load('res://Resources/Structures/WoodenTower.tres'),\
	[Creation.createWeapon(load('res://Resources/Weapons/Ballista.tres'),\
	 [load("res://Resources/Projectile/WoodenArrow.tres")])])

	Creation.createStructure(\
	Vector2(316, 243),\
	load('res://Resources/Structures/WoodenTower.tres'),\
	[Creation.createWeapon(load('res://Resources/Weapons/Ballista.tres'),\
	 [load("res://Resources/Projectile/WoodenArrow.tres")])])
	
	if !tilemap:
		tilemap = get_tree().get_first_node_in_group('TileMap')
	prepareTilemapNavigation()
	
#	Creation.createStructure(\
#	Vector2(416, 343),\
#	load('res://Resources/Structures/WoodenTower.tres'),\
#	[Creation.createWeapon(load('res://Resources/Weapons/Ballista.tres'),\
#	 [load("res://Resources/Projectile/WoodenArrow.tres")])])
#
#	Creation.createStructure(\
#	Vector2(216, 343),\
#	load('res://Resources/Structures/WoodenTower.tres'),\
#	[Creation.createWeapon(load('res://Resources/Weapons/Ballista.tres'),\
#	 [load("res://Resources/Projectile/WoodenArrow.tres")])])
	
func prepareTilemapNavigation():
	var usedCells = tilemap.get_used_cells(1)
	for cellPosition in usedCells:
		if tilemap.get_cell_tile_data(0, cellPosition) == null:
			tilemap.set_cell(0, cellPosition, 2, Vector2i(0, 0))
