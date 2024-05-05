extends Node2D
class_name Squad

@export var commander : Commander
@export var followerHolder : Node
@export var followerList : Array
@export var formationComponent : FormationComponent
@export var selectionVisuals : Node2D
@export var maxUnitAmount : int = 12

func _ready():
	if !commander:
		commander = load("res://Scenes/Units/Allies/Commander.tscn").instantiate()
		add_child(commander)
	if !formationComponent:
		formationComponent = load("res://Scripts/ComponentScripts/FormationComponent.gd").new()
		add_child(formationComponent)
	if !followerHolder:
		followerHolder = Node.new()
		followerHolder.name = 'Follower Holder'
		add_child(followerHolder)
	if !followerList:
		if !followerHolder.get_children():
			followerList = []
		else:
			followerList = followerHolder.get_children()
	$SquadUI.UpdateLabel(followerHolder.get_child_count() + 1, maxUnitAmount)
	if selectionVisuals:
		selectionVisuals.modulate.a = 0
	$SquadUI.modulate.a = 0
			
func reinforceSquad():
	if followerHolder.get_child_count() + 1 >= maxUnitAmount:
		print_debug('MAX UNIT COUNT')
		return
	if ! GameManager.GetResourceValue(GameManager.RESOURCE_ID.PEOPLE) >= 10:
		print_debug('INSUFFICIENT PEOPLE RESOURCE')
		return
	GameManager.ModifyResource(GameManager.RESOURCE_ID.PEOPLE, -10)
	var newSquadMember : Unit = load('res://Scenes/Units/Allies/Unit.tscn').instantiate()
	followerHolder.add_child(newSquadMember)
	followerList.append(newSquadMember)
	newSquadMember.global_position = commander.global_position\
			 + Vector2(randi_range(-90, 90), randi_range(-90, 90))
	followerList = followerHolder.get_children()
	$SquadUI.UpdateLabel(followerHolder.get_child_count() + 1, maxUnitAmount)
			
func MoveInFormation(_position : Vector2):
	var unitsFollowing : float = followerHolder.get_child_count() + 1
	formationComponent.unitWidth = 3
	formationComponent.unitDepth = ceili((unitsFollowing / 3))
	
	var destinationList : Array = []
	var commanderDestination : Vector2 = Vector2()
	var followerDestination : Array[Vector2]
	destinationList = formationComponent.EvaluatePoints(commander.global_position, _position)
	commanderDestination = destinationList[0]
	followerDestination = destinationList[1]
	
	var i : int = 0
	commander.navigationComponent.MoveTo(commanderDestination)
	
	for unit in followerList:
		unit.navigationComponent.MoveTo(followerDestination[i])
		i += 1

func OnSelection():
	print_debug('SELECTED: ', self.name)
	if selectionVisuals:
		selectionVisuals.modulate.a = 255
	$SquadUI.modulate.a = 255

func OnDeSelection():
	print_debug('DESELECTED: ', self.name)
	if selectionVisuals:
		selectionVisuals.modulate.a = 0
	$SquadUI.modulate.a = 0
