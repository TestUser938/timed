extends Control

@onready var counters = {
	"action": $Actions/Number,
	"timer": $Timer/Number
}

@onready var logs = $Logs

var timer: float = 0.0
var time_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.hud.connect(_update_counter)
	EventBus.log_text.connect(_log_text)

func _update_counter(type, value):
	var counter = counters.get(type)
	var tween_target = counter.get_parent()
	
	if int(value):
		if type == "action":
			counter.modulate = Color(1, 0, 0) if int(value) <= 1 else Color(1, 1, 1)
	
	counter.text = str(value) # str(int(counters.get(type).text) + 1)
	tween_target.scale = Vector2(.5, 1.5)
#	tween_target.rotation_degrees = randf_range(-45, 45)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(tween_target, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
#	tween.tween_property(tween_target, "rotation_degrees", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.play()
	
	if type == "timer": 
		time_started = true
		Globals.timer = float(value)

func _log_text(text: String):
	var message = logs.get_node("template").duplicate()
	logs.add_child(message)
	
	message.text = text
	message.visible = true
	
	var tween = create_tween()
	tween.tween_property(message, "self_modulate:a", 0, 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(message, "scale", Vector2.ZERO, .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func(): message.queue_free())
	
func _physics_process(delta: float) -> void:
	if not Globals.started: return;
	
	if time_started:
		Globals.timer -= delta
		Globals.current_time += delta
		
		counters["timer"].modulate = Color(1, 0, 0) if Globals.timer <= 5.0 else Color(1, 1, 1)
		counters["timer"].text = str(snapped(Globals.timer, 0.1))
		
		if Globals.timer <= 0:
			EventBus.reload.emit()
	
func _reset_counter():
	for i in counters:
		i.text = "0"
