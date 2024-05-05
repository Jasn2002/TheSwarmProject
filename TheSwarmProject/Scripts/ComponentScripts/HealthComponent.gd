extends Node2D
class_name HealthComponent

@onready var healthBar : TextureProgressBar = $HealthBar

@export var healthBarVisible : bool = true
@export var max_health : float
var current_health : float = self.max_health

const RESISTANCE_VALUES = Knowledge.RESISTANCE_VALUES
const DAMAGE_TYPE = Knowledge.DAMAGE_TYPE

#RESISTANCES
#Physical
@export var slashResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var bluntResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var pierceResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
#Elemental
@export var fireResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var electricResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var frostResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE
@export var energyResistance : RESISTANCE_VALUES = RESISTANCE_VALUES.NONE

signal damageTaken (damage : float)
signal hitpointsZero

func _ready():
	if !healthBarVisible:
		healthBar.modulate.a = 0
	
func onCreation(resource : Resource):
	if ! resource is EnemyResource and ! resource is UnitResource:
		return
	self.slashResistance = resource.slashResistance
	self.bluntResistance = resource.bluntResistance
	self.pierceResistance = resource.pierceResistance
	self.fireResistance = resource.fireResistance
	self.electricResistance = resource.electricResistance
	self.frostResistance = resource.frostResistance
	self.energyResistance = resource.energyResistance
	self.max_health = resource.health
	self.current_health = max_health
	healthBar.min_value = 0
	healthBar.max_value = max_health
	healthBar.set_value_no_signal(current_health)

func TakeDamage (damage : float, type : DAMAGE_TYPE) -> void:
	var calculatedDamage : float = damage
	var resistance : RESISTANCE_VALUES = ProcessResistances(type)
	
	match resistance:
		RESISTANCE_VALUES.CRITICAL:
			calculatedDamage *= 4
		RESISTANCE_VALUES.WEAK:
			calculatedDamage *= 2
		RESISTANCE_VALUES.RESISTANT:
			calculatedDamage /= 2
		RESISTANCE_VALUES.INMUNE:
			calculatedDamage *= 0
		_:
			pass
	
	damageTaken.emit(calculatedDamage)
	self.current_health -= calculatedDamage
	healthBar.value = current_health
	
	if current_health <= 0:
		hitpointsZero.emit()


func ProcessResistances (type : DAMAGE_TYPE) -> RESISTANCE_VALUES:
	match type:
		DAMAGE_TYPE.SLASH:
			return slashResistance
		DAMAGE_TYPE.BLUNT:
			return bluntResistance
		DAMAGE_TYPE.PIERCE:
			return pierceResistance
		DAMAGE_TYPE.FIRE:
			return fireResistance
		DAMAGE_TYPE.ELECTRIC:
			return electricResistance
		DAMAGE_TYPE.FROST:
			return frostResistance
		DAMAGE_TYPE.ENERGY:
			return energyResistance
		_:
			return RESISTANCE_VALUES.NONE
