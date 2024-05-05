extends Node2D

@onready var timer = $Timer

@export var timeBetweenSpawn : float = 5 # in seconds
@export var enemyWave : Array[Enemy]

var enemyTarget : Vector2

func _ready():
	enemyWave = Creation.createEnemyWave([load('res://Resources/Enemy/Crawler.tres')], 10)
	
	timer.timeout.connect(spawnEnemy)
	timer.wait_time = timeBetweenSpawn
	
	enemyTarget = get_tree().get_first_node_in_group('EnemyGoal').global_position
	
func spawnEnemy() -> void:
	var enemy : Enemy = enemyWave.pop_front()
	if !enemy:
		return
	get_tree().root.call_deferred('add_child', enemy)
	enemy.global_position = self.global_position
	enemy.navigationComponent.MoveTo(enemyTarget)
