extends AudioStreamPlayer2D

const tracks = [
	'Whoosh',
	'Walking 01',
	'Walking 02'
]

func _ready():
	randomize()
	
	connect("finished" ,self, "play_random_song")
	play_random_song()

func play_random_song():
	randomize()
	
	var rand_nb = Randi() % tracks.size()
	var audiostream = load('res://sfx/' + tracks[rand_nb] + '.ogg')
	set_stream(audiostream)
	play()
	pass