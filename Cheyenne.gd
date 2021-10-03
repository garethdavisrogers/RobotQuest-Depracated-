extends Node2D

func _on_Heisenberg_flicked(Cigarette, _position, _direction):
	var c = Cigarette.instance()
	add_child(c)
	c.start(_position, _direction)
