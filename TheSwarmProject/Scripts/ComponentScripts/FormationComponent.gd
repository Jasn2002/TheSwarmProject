extends Node2D
class_name FormationComponent

var unitWidth : int = 3
var unitDepth : int = 2
@export_range (0.1, 5) var spread : float = 1
@export_range (-5, 5) var nthOffset : float = 0
@export_range (0, 1) var noise : float = 0
var hollow : bool = false

func _ready():
	convertToPixels()
	
func convertToPixels():
	spread *= 48

func EvaluatePoints(from : Vector2, to : Vector2) -> Array:
	var middleOffset : Vector2 = Vector2(unitWidth * 0.5, unitDepth * 0.5)
	var vectorList : Array[Vector2] = []
	
	var formationAngleRad : float = getAngleInRadians(from, to)
	
	for x in unitWidth:
		for y in unitDepth:
			if !(hollow and (x != 0 and x != unitWidth -1 and y != 0 and y != unitDepth - 1)):
				var pos = Vector2(x + (0 if y % 2 == 0 else nthOffset ), y)
				
				pos -= middleOffset
				pos *= spread
				pos += GetNoise(pos)
			
				vectorList.append(to + pos.rotated(formationAngleRad))
		
	var commanderPosition : Vector2 = Vector2()
	for vector in vectorList:
		if vector.distance_to(to) < commanderPosition.distance_to(to):
			commanderPosition = vector
	vectorList.erase(commanderPosition)
		
	return [commanderPosition, vectorList]
	
func GetNoise(vector : Vector2) -> Vector2:
	var newNoise = FastNoiseLite.new()
	newNoise.noise_type = FastNoiseLite.TYPE_PERLIN
	var _noise = newNoise.get_noise_2d(vector.x * self.noise, vector.y * self.noise)
	return Vector2(noise, noise)
	
func getAverage2DPosition (fromVectors2 : Array[Vector2]) -> Vector2:
	var summedVector2 : Vector2 = Vector2()
	for vec2Pos in fromVectors2 : summedVector2 += vec2Pos
	return (summedVector2 / fromVectors2.size() as Vector2).snapped(Vector2(0.01, 0.01))
	
func getAngleInRadians(from : Vector2, to : Vector2) -> float:
	#Calculate angle for formation rotation
	var angleToPositionRad : float = from.angle_to_point(to)
	var angleToPositionDeg : float = snapped( remap(rad_to_deg(angleToPositionRad), -180, 180, 0, 360) ,1)
	var formationAngleRad : float = deg_to_rad(angleToPositionDeg + 90.0)
	return formationAngleRad
