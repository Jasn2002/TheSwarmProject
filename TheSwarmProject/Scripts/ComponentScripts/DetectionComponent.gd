extends Area2D
class_name DetectionComponent

@export var detectionRange : float = 200

func Init() -> void:
	var parent = get_parent()
	if parent.has_method("on_body_entered"):
		body_entered.connect(parent.on_body_entered)
	if parent.has_method("on_body_exited"):
		body_exited.connect(parent.on_body_exited)
	
	var child = get_child(0)
	child.shape = CircleShape2D.new()
	child.shape.radius = detectionRange
