extends Node

static func returnFormationPositions(
	formationDestination : Vector2,
	formationUnits : Array,
	formationParameters = [3, 1.0, 0.0]
) -> PackedVector2Array :
	
	#Classify prameters
	var formationSize : int = (formationUnits.size() as int)
	var formationDivisor : int = (formationParameters[0] as int)
	var formationSpread : float = (formationParameters[1] as float)
	
	#Current unit average position
	var currentUnitsPosition: Array[Vector2] = []
	for unit:Node2D in formationUnits:
		currentUnitsPosition.append(unit.global_position)
	var currentUnitPositionCenter : Vector2 = getAverage2DPosition(currentUnitsPosition)
	
	#Calculate angle fomr formation rotation
	var angleToPositionRad : float = currentUnitPositionCenter.angle_to_point(formationDestination)
	var angleToPositionDeg : float = snapped( remap(rad_to_deg(angleToPositionRad), -180, 180, 0, 360) ,1) - formationParameters[2]
	var formationAngleRad : float = deg_to_rad(angleToPositionDeg)
	
	#Creating the formation
	var horizontalSize : int = ceili(float(formationSize) / formationDivisor)
	print_debug(horizontalSize)
	var verticalSize : int = formationDivisor
	var spread : float = formationSpread * 48
	
	var formationPositions : Array[Vector2] = []
	var Hi : int = 0
	var Vi : int = 0
	for unit in formationUnits:
		var hSwapper : int = 1
		while Vi < verticalSize:
			while Hi < horizontalSize:
				
				hSwapper = -hSwapper
				var formationPosition : Vector2 = Vector2(
					(spread * Hi) * hSwapper,
					spread * Vi)
				print_debug('CALCULATIONS: ', 'spread: ', spread, ' HI: ', Hi, " hSwapper: ", hSwapper)
				print_debug('RESULT: ', formationPosition.x)
				formationPositions.append(
					formationDestination + (formationPosition).rotated(formationAngleRad))
					
				Hi += 1;
			Vi += 1;Hi = 0;
	
	return (formationPositions as PackedVector2Array)
	
	
static func getAverage2DPosition (fromVectors2 : Array[Vector2]) -> Vector2:
	var summedVector2 : Vector2 = Vector2()
	for vec2Pos in fromVectors2 : summedVector2 += vec2Pos
	return (summedVector2 / fromVectors2.size() as Vector2).snapped(Vector2(0.01, 0.01))
