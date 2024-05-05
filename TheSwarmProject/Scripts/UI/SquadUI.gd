extends Node2D

func _on_reinforce_button_button_up():
	var parent = get_parent()
	if parent.has_method('reinforceSquad'):
		parent.reinforceSquad()
		
func UpdateLabel(currentUnitAmount : int, maxUnitAmount : int):
	$Container/Label.text = "    " + str(currentUnitAmount) + '/' + str(maxUnitAmount) + '    '
