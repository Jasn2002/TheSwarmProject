extends ColorRect

var isMousePressed : bool = false
var initialMousePosition : Vector2
var finalMousePosition : Vector2

func _ready():
	self.size = Vector2.ZERO

func _input(event):
	if !event is InputEventMouse:
		return
	if event is InputEventMouseMotion:
		Update()
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_released():
			isMousePressed = false
			Update()
			Select()
			size = Vector2.ZERO
		elif event.button_index == 1 and event.is_pressed() and !isMousePressed:
			isMousePressed = true
			initialMousePosition = GetGlobalMousePosition()
			self.global_position = initialMousePosition
			

func Update():
	if !isMousePressed:
		return
	self.scale.x = -1 if GetGlobalMousePosition().x < initialMousePosition.x else 1
	self.scale.y = -1 if GetGlobalMousePosition().y < initialMousePosition.y else 1
	finalMousePosition = GetGlobalMousePosition()
	self.size = (finalMousePosition - initialMousePosition) * scale

func Select():
	var groupList = get_tree().get_nodes_in_group('Selectable')
	if !groupList:
		return
		
	var list : Array[Node2D] = []
	for node in groupList:
		var parentNode = node.get_parent()
		if get_global_rect().has_point(parentNode.global_position):
			list.append(parentNode)
	
	InputManager.UnitSelected(list)
	
func CheckDistance(position : Vector2) -> bool:
		return true if position <= finalMousePosition and position >= initialMousePosition else false
		
func GetGlobalMousePosition() -> Vector2:
	return get_tree().current_scene.get_global_mouse_position()
