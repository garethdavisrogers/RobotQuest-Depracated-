extends "res://Entity.gd"

var player_x = null
var player_y = null
onready var cooldown_timer = $CoolDownTimer
onready var detect_radius = $DetectRadius

func set_player_x(x):
	if player_x != x:
		player_x = x
		
func set_player_y(y):
	if player_y != y:
		player_y = y
		
func get_player_location():
	for body in detect_radius.get_overlapping_bodies():
		if body.TYPE == 'PLAYER':
			player_x = position.x - body.position.x;
			player_y = position.y - body.position.y
