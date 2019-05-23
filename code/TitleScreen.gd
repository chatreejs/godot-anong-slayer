extends Control

func _ready():
	$Menu/Buttons/PlayBtn.grab_focus()
	
func _physics_process(delta):
	if $Menu/Buttons/PlayBtn.is_hovered() == true:
		$Menu/Buttons/PlayBtn.grab_focus()
	if $Menu/Buttons/HowToPlay.is_hovered() == true:
		$Menu/Buttons/HowToPlay.grab_focus()
	if $Menu/Buttons/Exit.is_hovered() == true:
		$Menu/Buttons/Exit.grab_focus()

func _on_PlayBtn_pressed():
	get_tree().change_scene("res://scene/level/level_1.tscn")


func _on_HowToPlay_pressed():
	get_tree().change_scene("res://scene/HowToPlay.tscn")


func _on_Exit_pressed():
	get_tree().quit()