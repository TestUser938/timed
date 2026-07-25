extends PhysicsBody2D

@export var size: Vector2

@export var start_loc: Node2D
@export var end_loc: Node2D

var buffer = false
var start_pos: Vector2
var end_pos: Vector2

var timer = 0.0

func _ready() -> void:
	start_pos = start_loc.global_position
	end_pos = end_loc.global_position
	$Platform.scale = size
	
func _physics_process(delta: float) -> void:
	if not Globals.started: return;
	
	timer += delta
	
	var target = lerp(start_pos, end_pos, sin(timer))
	
	move_and_collide(target - global_position)
	# global_position = lerp(start_pos, end_pos, sin(timer))
