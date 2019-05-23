extends Control

func _ready():
	$main_menu_btn.grab_focus()
	
func _on_main_menu_btn_pressed():
	get_tree().change_scene("res://scene/TitleScreen.tscn")
