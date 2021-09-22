extends "res://Entity.gd"

onready var detect_radius = $detectRadius
onready var root = detect_radius.get_parent()

var player_x = null
var player_y = null

func _physics_process(_delta):
	damage_loop()
	if health <= 0:
		queue_free()
	match state:
		'default':
			state_default()
		'closing':
			state_closing()
		'attack':
			state_attack()

func state_default():
	get_player_location()
	if player_x != null or player_y != null:
		state_machine('closing')
	else:
		anim_switch('idle')
		movedir = Vector2(0, 0)
	

func state_closing():
	get_player_location()
	movement_loop()
	spritedir_loop()
	anim_switch('walk')
	if player_x == null or player_y == null:
		state_machine('default')
	else:
		var abs_x = abs(player_x)
		var abs_y = abs(player_y)
		if abs_x < 80 and abs_y < 10:
			state_machine('attack')
		else:
			var x_dir = 0
			var y_dir = 0
			if abs_x >= 80:
				x_dir = get_x_vector()
			if abs_y >= 10:
				y_dir = get_y_vector()
			movedir = Vector2(x_dir, y_dir)
		
	
func state_attack():
	get_player_location()
	var abs_x = abs(player_x)
	var abs_y = abs(player_y)
	if abs_x > 90 and abs_y > 20:
		state_machine('closing')
	else:
		if player_x > 0:
			spritedir = 'left'
		else:
			spritedir = 'right'
		anim_switch('liteattack1')

func get_player_location():
	for body in detect_radius.get_overlapping_bodies():
		if body.TYPE == 'PLAYER':
			var entity_x_coord = root.position.x
			var entity_y_coord = root.position.y
			var player_x_coord = body.position.x
			var player_y_coord = body.position.y
			get_x(entity_x_coord - player_x_coord)
			get_y(entity_y_coord - player_y_coord)
		

func get_x(x):
	if x == null:
		player_x = null
	elif player_x != x:
		player_x = x
		
func get_y(y):
	if y == null:
		player_y = null
	elif player_y != y:
		player_y = y
		
func get_x_vector():
	if player_x > 0:
		return -1
	elif player_x < 0:
		return 1
	else:
		return 0

func get_y_vector():
	if player_y > 0:
		return -1
	elif player_y < 0:
		return 1
	else:
		return 0
		
func _on_detectRadius_body_entered(_body):
	state_machine('closing')

func _on_detectRadius_body_exited(_body):
	player_x = null
	player_y = null
	state_machine('default')


func _on_anim_animation_finished(anim_name):
	var attack_anims = ['liteattack1left', 'liteattack1right',
	'liteattack2left', 'liteattack2right', 'liteattack3left', 'liteattack3right']
	for anim in attack_anims:
		if anim == anim_name:
			state_machine('default')
			break
