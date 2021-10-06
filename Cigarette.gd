extends Area2D

var velocity = Vector2(0, 0)
var damage = 10
var speed = 50

func start(_position, _direction):
	position = _position
	velocity = _direction * speed
	
func _process(delta):
	print(velocity)
	position.y += 10 * delta
	if velocity > 0:
		$anim.play('tumbleleft')
	else:
		$anim.play('tumbleright')
	position.x += velocity * delta

func _on_Cigarette_body_entered(body):
	if body.TYPE == 'PLAYER':
		queue_free()
