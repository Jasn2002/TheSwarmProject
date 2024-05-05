extends Area2D

func _on_body_entered(body):
	if !body.is_in_group('Enemy'):
		return
	body.Die()
	print_debug('HEALTH LOST!')
	$"..".healthPoints -= 1
	if $"..".healthPoints <= 0:
		get_tree().quit()
