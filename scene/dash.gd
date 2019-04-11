extends AnimatedSprite

func init(pos, sprite):
	frames = sprite.frames
	animation = sprite.animation
	position = pos
	flip_h = sprite.flip_h
	frame = sprite.frame
	
	$anim.play('New')
	yield($anim, "animation_finished")
	queue_free()