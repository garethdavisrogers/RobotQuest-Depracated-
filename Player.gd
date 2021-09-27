extends "res://Entity.gd"
var combo = 0
onready var dead = false
onready var combo_timer = $ComboTimer

func _physics_process(_delta):
	send_z_index()
	if health <= 0:
		queue_free()
	else:
		match state:
			'default':
				state_default()
			'attack':
				state_attack()

func state_default():
	movement_loop()
	spritedir_loop()
	controls_loop()
	damage_loop()
		
	if movedir != Vector2(0, 0):
		acceleration_loop()
		if speed > (max_speed * 3)/4:
			anim_switch('run')
		else:
			anim_switch('walk')
	else:
		speed = 0
		anim_switch('idle')
		
	if Input.is_action_just_pressed("lite_attack"):
		state_machine('attack')

func state_attack():
	movedir = Vector2(0, 0)
	var time_remaining = combo_timer.get_time_left()
	match combo:
		0:
			anim_switch('liteattack1')
			combo_timer.start(0.4)
			combo = 1
			
		1:
			if  time_remaining > 0 and time_remaining < 0.18:
				anim_switch('liteattack2')
				combo_timer.start(0.4)
				combo = 2
				
		2:
			if  time_remaining > 0 and time_remaining < 0.2:
				anim_switch('liteattack3')
				combo_timer.start(0.4)
				combo = 3
		3:
			return
	
func controls_loop():
	var LEFT = Input.is_action_pressed('move_left')
	var RIGHT = Input.is_action_pressed('move_right')
	var UP = Input.is_action_pressed('move_up')
	var DOWN = Input.is_action_pressed('move_down')
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)


func _on_ComboTimer_timeout():
	combo = 0
	state_machine('default')
	


func _on_anim_animation_finished(anim_name):
	var attack_anims = ['liteattack1left', 'liteattack1right',
	'liteattack2left', 'liteattack2right', 'liteattack3left', 'liteattack3right']
	for anim in attack_anims:
		if anim == anim_name:
			state_machine('default')
			break


