extends Node2D

export (String, FILE, "*tscn") var next_right
export (String, FILE, "*tscn") var next_left

func _ready():

	match GLOBAL.sens:
		GLOBAL.LEFT:
			$Player.global_position = $utils/spawn_right.global_position
		GLOBAL.RIGHT:
			$Player.global_position = $utils/spawn_left.global_position

func _on_exit_right_body_entered(body):
	if body.name == 'Player':
		GLOBAL.set_sens(GLOBAL.RIGHT)
		get_tree().change_scene(next_right)

func _on_exit_left_body_entered(body):
	if body.name == 'Player':
		GLOBAL.set_sens(GLOBAL.LEFT)
		get_tree().change_scene(next_left)