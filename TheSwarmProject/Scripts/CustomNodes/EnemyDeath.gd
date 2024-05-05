extends AnimatedSprite2D

func _ready():
	
	$SFXPlayer.play()
	self.play("default")
	await self.animation_finished
	self.queue_free()
