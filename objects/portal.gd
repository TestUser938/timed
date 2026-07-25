extends Area2D

@export var enter_loc: Node2D
@export var exit_loc: Node2D

@onready var enter = $Enter
@onready var exit = $Exit
@onready var line = $Line

var buffer = false
var enter_pos: Vector2
var exit_pos: Vector2

func _ready() -> void:
	enter_pos = enter_loc.global_position
	exit_pos = exit_loc.global_position
	
	enter.global_position = enter_pos
	exit.global_position = exit_pos
	
	line.set_point_position(0, enter_loc.position)
	line.set_point_position(1, exit_loc.position)


func _on_body_entered(body: Node2D) -> void:
	if buffer: return;
	if body is CharacterBody2D or body is RigidBody2D:
		var diff_enter = (body.global_position - enter_pos).length()
		var diff_exit = (body.global_position - exit_pos).length()
		
		if diff_enter < diff_exit:
			body.global_position = exit_pos
		else: body.global_position = enter_pos
		
		buffer = true
		await get_tree().create_timer(0.1).timeout
		buffer = false
