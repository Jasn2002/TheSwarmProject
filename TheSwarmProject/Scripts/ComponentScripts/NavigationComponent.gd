extends NavigationAgent2D
class_name NavigationComponent

@onready var parent : Node2D = get_parent()

var isTargetReached : bool = true

func _physics_process(_delta):
	if self.isTargetReached:
		parent.velocity = Vector2.ZERO
		return
	if self.is_navigation_finished():
		isTargetReached = true
		return
	if !target_position:
		return
	parent.velocity = (self.get_next_path_position() - parent.global_position).normalized() * parent.speed
	parent.move_and_slide()
	
func MoveTo(position : Vector2):
	self.target_position = position
	isTargetReached = false
