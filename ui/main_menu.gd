extends Control

@onready var buttons = {
	"start": $Buttons/Start,
	"options": $Buttons/Options,
}

@onready var settings = {
	"burst_key": $Options/BurstKey,
	"volume": $Options/Volume
}

@onready var options = $Options
@onready var best = $BestTime

var changing_key = false

func _ready() -> void:
	for i in buttons:
		var button: Button = buttons.get(i, "start")
		button.pressed.connect(_pressed.bind(i))
	
	update_record()
	visibility_changed.connect(update_record)
#	_set_keybind("burst")


		
func _pressed(i):
	if i == "start":
		visible = false
		Globals.started = true
		EventBus.reload.emit()
		Globals.current_time = 0.0
	elif i == "options":
		options.visible = not options.visible



func _on_volume_value_changed(value: float) -> void:
	Globals.volume = linear_to_db(value/100.0)
	


func update_record() -> void:
	await get_tree().process_frame
	var best_time = Datastore.load_time()
	best.text = str("best time: ", snapped(best_time, 0.1), "s") if best_time != null and best_time > 0.0 else "no record"
	
	
"""
func _set_keybind(action):
	var action_events = InputMap.action_get_events(action)
	var action_event = action_events[0]
	var action_keycode = action_event.as_text() # OS.get_keycode_string(action_event.physical_keycode)
	
	settings["burst_key"].text = str("[", action_keycode, "]")

func _on_burst_key_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("yo")
		settings["burst_key"].text = "waiting..."
		set_process_unhandled_key_input(true)
		changing_key = true
	else:
		changing_key = false
		set_process_unhandled_key_input(false)
		_set_keybind("burst")

	
	
func _unhandled_key_input(event: InputEvent) -> void:
	if not changing_key: return
	var action_events = InputMap.action_get_events("burst")
	var action_event = action_events[0]
	if action_event.as_text() == "Left Mouse Button": return
	
	InputMap.action_erase_event("burst", action_event)
	InputMap.action_add_event("burst", event)
	
	settings["burst_key"].button_pressed = false
	changing_key = false
	_set_keybind("burst")
"""
