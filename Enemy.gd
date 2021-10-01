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
			player_x = position.x - body.position.x
			player_y = position.y - body.position.y
			
func get_movedir():
	var abs_x = abs(player_x)
	var abs_y = abs(player_y)
	if abs_x < 80 and abs_y < 10:
		state_machine('attack')
	else:
		cooldown_timer.start(0.1)
		var x_dir = 0
		var y_dir = 0
		if abs_x >= 80:
			x_dir = get_vector(player_x)
		if abs_y >= 10:
			y_dir = get_vector(player_y)
		movedir.x = x_dir
		movedir.y = y_dir

func get_vector(plane):
	if plane > 0:
		return -1
	elif plane < 0:
		return 1
	else:
		return 0
