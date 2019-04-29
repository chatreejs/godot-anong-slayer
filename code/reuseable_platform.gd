extends Node2D

export (int) var speed = 2.0
export var longueur = Vector2(300, 0)

func _ready():
	move()
	pass
	
func move():
	$MovingTween.interpolate_property(
		self,
		"position",
		global_position,
		global_position + longueur,
		speed,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
		)
	$MovingTween.start()

func _on_Tween_tween_completed(object, key):
	longueur *= -1
	move()
