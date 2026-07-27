extends Control

@onready var buttons = {
	"resume": $Buttons/Resume,
	"reload": $Buttons/Reload,
	"restart": $Buttons/Restart,
	"exit": $Buttons/Exit,
}

@onready var stats = {
	"time": $Stats/Time,
	"best": $Stats/Best,
	"type": $Stats/Type,
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Globals.started:
		visible = not visible
		Globals.started = not Globals.started
#		print(str(Globals.started))
		
		stats["time"].text = str("current: ", snapped(Globals.current_time, 0.1), "s")
		stats["best"].text = str("best: ", snapped(Datastore.load_time(), 0.1), "s")

func _ready() -> void:
	for i in buttons:
		var button: Button = buttons.get(i, "resume")
		button.pressed.connect(_pressed.bind(i))
		
func _pressed(i):
	if i == "resume":
		visible = false
		Globals.started = true
	elif i == "reload":
		visible = false
		EventBus.reload.emit()
		Globals.started = true
	elif i == "restart":
		visible = false
		EventBus.level.emit(0, false)
		EventBus.reload.emit(true)
		Globals.current_time = 0.0
		Globals.started = true
	elif i == "exit":
		visible = false
		Globals.started = false
		EventBus.level.emit(0, false)
		EventBus.reload.emit(true)
		get_parent().get_node("Menu").visible = true
