extends KinematicBody2D

export(int) var speed = 0
export(int) var max_speed = 300
export(int) var acceleration = 2
export(int) var health = 1
export(String) var TYPE = 'ENEMY'
var movedir = Vector2(0, 0)
var knockdir = Vector2(0, 0)
var spritedir = 'left'
var hitstun = 0
onready var liteknockback = $damageBox.get('knockback')
onready var anim = $anim
onready var parent = self.get_parent()
var state = 'default'

func state_machine(s):
	if state != s:
		state = s

func send_z_index():
	var z_info = self.position.y
	parent.position.y = z_info
	
func movement_loop():
	clamp_entity()
	var motion
	if hitstun == 0:
		motion = movedir.normalized() * speed
	else:
		motion = knockdir.normalized() * speed * 2.5
	move_and_slide(motion, Vector2(0, 0))

func spritedir_loop():
	match movedir:
		Vector2(1, 0):
			spritedir = 'right'
		Vector2(-1, 0):
			spritedir = 'left'
			
func acceleration_loop():
	var abs_speed = abs(speed)
	if abs_speed < max_speed:
		speed += acceleration
		
func anim_switch(animation):
	var new_anim = str(animation, spritedir)
	if anim.current_animation != new_anim:
		anim.current_animation = new_anim
		
func damage_loop():
	if hitstun > 0:
		hitstun -= 1
	for area in $hitBox.get_overlapping_areas():
		var area_damage = area.get('DAMAGE')
		var area_type = area.get_parent().get('TYPE')
		if hitstun == 0 and area_damage != null and area_type != TYPE:
			health -= area.get('DAMAGE')
			hitstun = 10
			knockdir = global_transform.origin - area.global_transform.origin
			
func slow_backward_movement(default_speed):
	if spritedir == 'left' and movedir.x > 0 or spritedir == 'right' and movedir.x < 0:
		speed = default_speed / 2

func clamp_entity():
	position.x = clamp(position.x, 0, 5000)
	position.y = clamp(position.y, 0, 600)

