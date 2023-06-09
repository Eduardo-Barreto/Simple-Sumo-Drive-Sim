extends Area2D

signal hit

func _on_body_entered(body:Node):
	if body is KinematicBody2D:
		call_deferred("emit_signal", "hit")
		call_deferred("queue_free")
		pass
