extends RigidBody2D



func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		print("touched")
		apply_central_impulse(body.velocity * 100) # no worky
