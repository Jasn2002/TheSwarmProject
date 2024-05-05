extends CanvasLayer

#@onready var resource_display = $Container/TopMenuBackground/ResourceDisplay

var activeButton : Button = null

@onready var partsDisplay : ResourceDisplay = $Container/TopMenuBackground/ResourceDisplay/PartsDisplay
@onready var peopleDisplay : ResourceDisplay = $Container/TopMenuBackground/ResourceDisplay/PeopleDisplay
@onready var crystalDisplay : ResourceDisplay = $Container/TopMenuBackground/ResourceDisplay/CrystalDisplay


func setActiveButton(button: Button):
	activeButton = button
	pass
	
func _input(event):
	if !activeButton:
		return
	if event is InputEventMouseButton and event.is_released():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				activeButton.action()
			MOUSE_BUTTON_RIGHT:
				activeButton = null

func UpdateResources():
	partsDisplay.UpdateValue(GameManager.partsResource)
	peopleDisplay.UpdateValue(GameManager.peopleResource)
	crystalDisplay.UpdateValue(GameManager.crystalResource)
