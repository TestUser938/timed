extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_VELOCITY = 2000.0

var target_velocity = Vector2.ZERO
var current_velocity = Vector2.ZERO

var states = {
	"is_submerged": false,
	"is_frozen": false,
}

@onready var dir: Line2D = $Direction
@onready var mesh: MeshInstance2D = $Mesh
@onready var particles: Node2D = $Particles

var raw_input = Vector2.ZERO
var spawn_location

func _ready() -> void:
	spawn_location = global_position

func _physics_process(delta: float) -> void:
	raw_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	dir.set_point_position(1, raw_input.normalized() * 50.0)
	
	if not states["is_frozen"]:
		
		if not states["is_submerged"]:
			# H MOMENTUM #
			current_velocity.x = lerp(current_velocity.x, target_velocity.x, (5.0 if is_on_floor() else 1.0) * delta)
			
			# GRAVITY #
			if not is_on_floor():
				current_velocity.y += get_gravity().y * delta
			else:
				current_velocity.y = 0
				
			# JUMPING #
			if Input.is_action_pressed("ui_accept") and is_on_floor():
				current_velocity.y = JUMP_VELOCITY
				EventBus.action.emit("jump")
		else:
			current_velocity = lerp(current_velocity, target_velocity, 5.0 * delta)
			target_velocity.y = raw_input.y * SPEED
		
		
		# squish squash @
		mesh.look_at(global_position + current_velocity)
		mesh.scale = lerp(mesh.scale, Vector2(clamp((current_velocity.length()/200.0) / 1, 1, 3), clamp(1 / (current_velocity.length()/200.0) if !is_on_floor() else 1, 0.5, 1)), 5.0 * delta)

		
		# dashing!!! #
		if Input.is_action_just_pressed("burst"):
			burst()


		# H MOVE #
		if raw_input:
			target_velocity.x = raw_input.x * SPEED
		else:
			target_velocity.x = move_toward(target_velocity.x, 0, SPEED)
		
		
		$debug.text = str(round(current_velocity.x), ", ", round(current_velocity.y))
		velocity = current_velocity
		move_and_slide()

func burst():
	EventBus.action.emit("burst")
	particles.get_node("Spark").emitting = true
	
	if raw_input.length() > 0:
		current_velocity = raw_input * (DASH_VELOCITY if is_on_floor() and raw_input.y == 0 else DASH_VELOCITY/4.0)
	else:
		particles.get_node("Burst").emitting = true
		states["is_frozen"] = true
		await get_tree().create_timer(.25).timeout
		states["is_frozen"] = false
	

func die():
	particles.get_node("Burst").emitting = true
	
	global_position = spawn_location
	particles.get_node("Spawn").emitting = true
