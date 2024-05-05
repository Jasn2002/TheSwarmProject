extends Node

@onready var camera2D : Camera2D = get_tree().current_scene.camera

var cameraZoomSpeed : float = 10
var cameraMoveSpeed : float = 500

enum STATES {
	DEFAULT,
	BUILD,
	UNIT_SELECTED
}

var currentState : STATES = STATES.DEFAULT
var selectedUnit : Node2D

var buildingPreview : BuildingPreview
var buildAction : Callable

func _ready():
	if !buildingPreview:
		buildingPreview = load('res://Scenes/UI/BuildingPreview.tscn').instantiate()
		get_tree().current_scene.add_child(buildingPreview)
		get_tree().get_first_node_in_group('GUI').add_sibling(buildingPreview)

func _input(event):
	if currentState == STATES.UNIT_SELECTED and !selectedUnit:
		currentState = STATES.DEFAULT
	processState(event)
	
func _physics_process(delta):
	camera2D.position.y += (Input.get_axis("Up", "Down")) * cameraMoveSpeed * delta
	if camera2D.position.y <= -98:
		camera2D.position.y = -98
	camera2D.position.x += (Input.get_axis("Left", "Right")) * cameraMoveSpeed * delta
	if camera2D.position.x <= -126:
		camera2D.position.x = -126
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and currentState == STATES.UNIT_SELECTED:
		currentState = STATES.DEFAULT
		SelectUnit(null)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		camera2D.zoom += Vector2(0.01, 0.01) * cameraZoomSpeed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		camera2D.zoom -= Vector2(0.01, 0.01) * cameraZoomSpeed
	
			
func processState(event):
	#print_debug(currentState)
	match currentState:
		STATES.DEFAULT:
			pass
		STATES.UNIT_SELECTED:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_released():
					if !selectedUnit.has_method('MoveInFormation'):
						return
					selectedUnit.MoveInFormation(get_tree().current_scene.get_global_mouse_position())
		STATES.BUILD:
			if event is InputEventMouseButton and event.is_released():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						if buildingPreview.PlaceBuilding():
							pass
						
					MOUSE_BUTTON_RIGHT:
						currentState = STATES.DEFAULT
						buildingPreview.SetActive(false)


func SelectUnit(unit : Node2D) -> void:
	if selectedUnit != null:
		selectedUnit.OnDeSelection()
	if !unit:
		if selectedUnit:
			selectedUnit.OnDeSelection()
		selectedUnit = null
		return
	selectedUnit = unit
	selectedUnit.OnSelection()
	currentState = STATES.UNIT_SELECTED
		
func buildCommandSelected(structureResource : StructureResource):
	currentState = STATES.BUILD
	buildingPreview.buildingResource = structureResource
	buildingPreview.SetActive()
