extends PanelContainer
class_name TooltipOld

@onready var area2D : Area2D = $Area2D
@onready var content = $Content

@export var triggerDistance : int = 20 #in pixels, should match half the width of the owner Sprite

func _ready():
	customHide()
	self.mouse_entered.connect(customShow)
	self.mouse_exited.connect(customHide)
	owner.ready.connect(onCreation)
	
func customShow():
	print_debug(self.global_position.distance_to(get_global_mouse_position()))
	await get_tree().create_timer(0.5).timeout
	# if there are less than x pixels from the mouse to the tooltip, it triggers. Othewise it doesn't
	if !(get_parent().global_position.distance_to(get_global_mouse_position()) < triggerDistance):
		return
	self.modulate.a = 255
func customHide():
	self.modulate.a = 0
	
func onCreation():
	area2D.visible = true
	self.global_position = get_parent().global_position
	#area2D.global_position = get_parent().global_position
	if !owner.resource:
		return
	if owner.resource is StructureResource:
		CreateStructureTooltip(owner)
	if owner.resource is WeaponResource:
		CreateWeaponTooltip(owner)
	if owner.resource is ProjectileResource:
		CreateProjectileTooltip(owner)
	
		
func debug():
	print_debug(self.global_position)
	print_debug(get_parent().global_position)


func CreateStructureTooltip(ownerNode : Object):
	var ownerResource : StructureResource = ownerNode.resource
	if !ownerResource is StructureResource:
		return
	var textureRect = TextureRect.new()
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP
	textureRect.texture = ownerResource.visuals
	content.add_child(textureRect)
	var label = Label.new()
	label.text = ''
	label.text += ownerResource.name + '\n'
	label.text += 'Slots: ' + str(ownerResource.weaponSlots) + '\n'
	content.add_child(label)
	if !ownerNode.weaponsMounted:
		return
	for weapon in owner.weaponsMounted:
		CreateWeaponTooltip(weapon)


func CreateWeaponTooltip(ownerNode : Object):
	var ownerResource : WeaponResource = ownerNode.resource
	if !ownerResource is WeaponResource:
		return
	var textureRect = TextureRect.new()
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP
	textureRect.texture = ownerResource.visuals
	content.add_child(textureRect)
	var label = Label.new()
	label.text = ''
	label.text += ownerResource.name + '\n'
	label.text += 'Reload Time: ' + str(ownerResource.reloadTime) + '\n'
	label.text += 'Detection Range: ' + str(ownerResource.detectionRange) + '\n'
	content.add_child(label)
	if !ownerNode.projectilesLoaded:
		return
	for projectile in ownerNode.projectilesLoaded:
		CreateProjectileTooltip(projectile)


func CreateProjectileTooltip(ownerNode : Object):
	var ownerResource : ProjectileResource = ownerNode.resource
	if !ownerResource is ProjectileResource:
		return
	var textureRect = TextureRect.new()
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP
	textureRect.texture = ownerResource.visuals
	content.add_child(textureRect)
	var label = Label.new()
	label.text = ''
	label.text += ownerResource.name + '\n'
	label.text += 'Damage: ' + str(ownerResource.damage) + '\n'
	label.text += 'Speed: ' + str(ownerResource.speed) + '\n'
	label.text += 'Speed: ' + str(ownerResource.expirationTime) + '\n'
	content.add_child(label)
