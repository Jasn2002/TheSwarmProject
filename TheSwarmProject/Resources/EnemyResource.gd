extends Resource
class_name EnemyResource

@export var name : String = 'Enemy'
@export var id : String = '020'
@export var speed : float = 100
@export var health : float = 5
@export var threatValue : int = 1

#RESISTANCES
const RESISTANCE_VALUES = Knowledge.RESISTANCE_VALUES
@export var slashResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var bluntResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var pierceResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var fireResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var electricResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var frostResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var energyResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE

