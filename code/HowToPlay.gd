extends Control

func _ready():
	$BackBtn.grab_focus()
	
	


func _on_BackBtn_pressed():
	get_tree().change_scene("res://scene/TitleScreen.tscn")
