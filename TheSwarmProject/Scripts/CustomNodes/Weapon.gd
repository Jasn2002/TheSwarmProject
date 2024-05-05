extends Node2D
class_name Weapon

@onready var reloadTimer : Timer = $ReloadTimer
@onready var projectileHolder : Node2D = $ProjectileHolder

@export var resource : WeaponResource
@export var isReloading : bool = false

var targetAcquisitionComponent : TargetAcquisitionComponent
var projectilesList : Array[ProjectileResource]
var projectilesLoaded : Array[Projectile]
var maxProjectile_Loaded : int
var reloadTime : float
var detectionRange : float

func onCreation (_resource : WeaponResource, projectileList : Array[ProjectileResource]) -> void:
	if !_resource:
		return
	self.resource = _resource
	self.name = _resource.name
	self.texture = _resource.visuals
	reloadTime = _resource.reloadTime
	self.projectilesList = projectileList
	self.maxProjectile_Loaded = projectileList.size()
	self.detectionRange = _resource.detectionRange

func _ready():
	reloadTimer.wait_time = reloadTime
	reloadTimer.one_shot = true
	reloadTimer.autostart = false
	reloadTimer.timeout.connect(Reload)
	
	targetAcquisitionComponent = load('res://Scenes/Components/TargetAcquisitionComponent.tscn').instantiate()
	add_child(targetAcquisitionComponent)
	targetAcquisitionComponent.detectionRange = self.detectionRange
	targetAcquisitionComponent.Init()
	
	Reload()
	
func _process(_delta):
	if isReloading:
		return
	if !targetAcquisitionComponent.targetsInRange:
		return
	var target = targetAcquisitionComponent.acquireTarget()
	Fire(target)
	
	

func Fire (target : CharacterBody2D) -> void :
	
	if !target:
		return
	
	await create_tween().tween_property(self, 'rotation',\
	self.rotation + get_angle_to(target.global_position), 0.5).finished
	
	for p in projectilesLoaded:
		if !target:
			break
		if target.is_queued_for_deletion():
			break
		if p.velocity == Vector2.ZERO:
			p.Fly(target)
			projectilesLoaded.erase(p)
			p.reparent(get_tree().root)
	reloadTimer.start(reloadTime)
	isReloading = true
	
func Reload () -> void :
	for p in projectilesList:
		if projectileHolder.get_child_count() >= maxProjectile_Loaded:
			break
		var newProjectile = Creation.createProjectile(p)
		projectilesLoaded.append(newProjectile)
		projectileHolder.add_child(newProjectile)
	isReloading = false
