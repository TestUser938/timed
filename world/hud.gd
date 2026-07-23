extends Control

@onready var counters = {
	"action": $Actions/Number,
	"timer": $Timer/Number
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.action.connect(_update_counter.bind("action"))

func _update_counter(value, type):
	counters.get(type).text = str(int(counters.get(type).text) + 1)
	
func _reset_counter():
	for i in counters:
		i.text = "0"
