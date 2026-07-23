extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_VELOCITY = 2000.0

var target_velocity = Vector2.ZERO
var current_velocity = Vector2.ZERO

@onready var dir: Line2D = $Direction

func _physics_process(delta: float) -> void:
	current_velocity.x = lerp(current_velocity.x, target_velocity.x, 5.0 * delta)
	
	var raw_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	dir.set_point_position(1, current_velocity.normalized() * 50.0)

	if not is_on_floor():
		current_velocity.y += get_gravity().y * delta
	else:
		current_velocity.y = 0


	if Input.is_action_pressed("ui_accept") and is_on_floor():
		current_velocity.y = JUMP_VELOCITY
		EventBus.action.emit("jump")
	
	if Input.is_action_just_pressed("burst"):
		current_velocity = raw_input * (DASH_VELOCITY if is_on_floor() else DASH_VELOCITY/4.0)
		EventBus.action.emit("burst")


	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		target_velocity.x = direction * SPEED
	else:
		target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
	
	$debug.text = str(round(current_velocity.x), ", ", round(current_velocity.y))
	velocity = current_velocity
	move_and_slide()
