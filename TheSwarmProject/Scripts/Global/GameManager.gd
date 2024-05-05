extends Node

var partsResource : int = 77
var peopleResource : int = 40
var crystalResource : int = 15

enum RESOURCE_ID {
	PARTS,
	PEOPLE,
	CRYSTALS
}

func ModifyResource(whichRes : RESOURCE_ID, amount : int): #Value can be negative
	match whichRes:
		RESOURCE_ID.PARTS:
			partsResource += amount
		RESOURCE_ID.PEOPLE:
			peopleResource += amount
		RESOURCE_ID.CRYSTALS:
			crystalResource += amount
		_:
			pass
	get_tree().get_first_node_in_group('GUI').UpdateResources()
	
func GetResourceValue(whichRes : RESOURCE_ID) -> int:
	var value : int = 0
	match whichRes:
		RESOURCE_ID.PARTS:
			value = partsResource
		RESOURCE_ID.PEOPLE:
			value = peopleResource
		RESOURCE_ID.CRYSTALS:
			value = crystalResource
		_:
			pass
	return value
