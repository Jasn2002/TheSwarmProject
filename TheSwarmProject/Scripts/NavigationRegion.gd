extends NavigationRegion2D

@onready var structures = $Structures

func _ready():
	bake_navigation_polygon()
	print_debug(get_child(0).tile_set.get_physics_layer_collision_mask(0))
