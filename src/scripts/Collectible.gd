extends Area2D

signal hit

func _on_body_entered(body:Node):
	if body is KinematicBody2D:
		emit_signal("hit")
		queue_free()
		pass
