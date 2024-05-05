extends Area2D
class_name SelectableComponent

@export_range(10, 128) var radius : float = 32

func _ready():
	$CollisionShape2D.shape.radius = self.radius


func _on_input_event(_viewport, event, _shape_idx):
	if InputManager.currentState == InputManager.STATES.BUILD:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		InputManager.SelectUnit(get_parent())
