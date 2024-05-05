extends Node2D


@onready var screen = $CanvasLayer/Screen

func switchScene ():
	get_tree().change_scene_to_packed(preload("res://Scenes/Maps/test_scene.tscn"))

func quitGame():
	get_tree().quit()
