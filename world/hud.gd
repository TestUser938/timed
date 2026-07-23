extends Control

@onready var counters = {
	"action": $Actions/Number,
	"timer": $Timer/Number
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.action.connect(_update_counter.bind("action"))

func _update_counter(value, type):
	var counter = counters.get(type)
	var tween_target = counter.get_parent()
	
	counter.text = str(int(counters.get(type).text) + 1)
	tween_target.scale = Vector2(.5, 1.5)
	tween_target.rotation_degrees = randf_range(-45, 45)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(tween_target, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(tween_target, "rotation_degrees", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.play()
	
func _reset_counter():
	for i in counters:
		i.text = "0"
