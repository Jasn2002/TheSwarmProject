extends Node
class_name Tooltip

#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
@export var visuals_res: PackedScene
@export var owner_path: NodePath
@export var follow_mouse: bool = true
@export_range(0, 10, 0.05) var delay : float = 0.5
@export_range(-100, 100, 1) var offset_x : float
@export_range(-100, 100, 1) var offset_y : float
@export_range(0, 100, 1) var padding_x : float
@export_range(0, 100, 1) var padding_y : float


#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _visuals: Control
var _timer: Timer


#####################################
# ONREADY VARIABLES
#####################################
@onready var owner_node = get_node(owner_path)
@onready var offset: Vector2 = Vector2(offset_x, offset_y)
@onready var padding: Vector2 = Vector2(padding_x, padding_y)
@onready var extents: Vector2


#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	# create the visuals
	_visuals = visuals_res.instantiate()
	add_child(_visuals)
	# calculate the extents
	extents = _visuals.size
	# connect signals
	owner_node.mouse_entered.connect(_mouse_entered)
	owner_node.mouse_exited.connect(_mouse_exited)
	# initialize the timer
	_timer = Timer.new()
	add_child(_timer)
	_timer.timeout.connect(_custom_show)
	# default to hide
	_visuals.hide()


func _process(_delta: float) -> void:
	if _visuals.visible:
		var border = Vector2(get_viewport().size) - padding
		extents = _visuals.size
		var base_pos = _get_screen_pos()
		# test if need to display to the left
		var final_x = base_pos.x + offset.x
		if final_x + extents.x > border.x:
			final_x = base_pos.x - offset.x - extents.x
		# test if need to display below
		var final_y = base_pos.y - extents.y - offset.y
		if final_y < padding.y:
			final_y = base_pos.y + offset.y
		_visuals.position = Vector2(final_x, final_y)


#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _mouse_entered() -> void:
	_timer.start(delay)


func _mouse_exited() -> void:
	_timer.stop()
	if ! owner_node.global_position.distance_to(get_tree().current_scene.get_global_mouse_position())\
	 > 40:
		return
	_visuals.hide()


func _custom_show() -> void:
	_timer.stop()
	_visuals.show()


func _get_screen_pos() -> Vector2:
	if follow_mouse:
		return get_viewport().get_mouse_position()
	
	
	var position = Vector2()
	
	if owner_node is Node2D:
		position = owner_node.get_global_transform_with_canvas().origin
	elif owner_node is Control:
		position = owner_node.position
	
	return position



#Credit for Indie Quest YouTube Channel for this piece of code!#
