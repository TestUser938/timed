extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.current_speed *= 3.0
		body.burst(true)
