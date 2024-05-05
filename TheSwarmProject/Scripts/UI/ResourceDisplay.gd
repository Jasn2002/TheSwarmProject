extends HBoxContainer
class_name ResourceDisplay

@onready var icon = $Icon
@onready var quantity = $Quantity

@export var iconImage : CompressedTexture2D = load('res://Images/UI/Icons/CrystalIconBackground.png')

var curentValue : int

func _ready():
	icon.texture = iconImage

func UpdateValue(newValue : int) -> void:
	curentValue = int(quantity.text)
	if curentValue == newValue:
		return
	var tween = create_tween()
	tween.tween_method(SetLabelText, curentValue, newValue, 0.5)

func SetLabelText(value: int):
	$Quantity.text = str(value)

