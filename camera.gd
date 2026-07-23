extends Camera2D

@export var target: Node2D
@export var target_offset: Vector2

var ok = false

func _ready() -> void:
	if target: ok = true;




func _process(delta: float) -> void:
	if not ok: return;
	
	position = Vector2(target.global_position.x, 0) + target_offset 
