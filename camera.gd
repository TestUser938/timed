extends Camera2D

@export var target: Node2D
@export var target_offset: Vector2

var ok = false

func _ready() -> void:
	if target: ok = true;


func _input(event: InputEvent) -> void:
	var zoom_change = 0.0
	
	if event.is_action_pressed("zoom_in"): zoom_change = .1
	elif event.is_action_pressed("zoom_out"): zoom_change = -.1
	
	if zoom_change != 0.0:
		zoom = Vector2(clamp(zoom.x + zoom_change, 0.5, 10), clamp(zoom.y + zoom_change, 0.5, 10))

func _process(delta: float) -> void:
	if not ok: return;
	
	var y = clamp(target.global_position.y, -1000, 0)
	position = lerp(position, Vector2(target.global_position.x, y if y >= 0 else target.global_position.y - target_offset.y) + target_offset, 5.0 * delta)
