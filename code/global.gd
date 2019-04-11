extends Node

enum {LEFT, RIGHT, UP, DOWN}

var sens = RIGHT setget set_sens

func set_sens(value):
	sens = value