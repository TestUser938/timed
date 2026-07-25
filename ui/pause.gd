extends Control

@onready var buttons = {
	"resume": $Buttons/Resume,
	"reset": $Buttons/Reset,
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
		print(str(Globals.started))

func _ready() -> void:
	for i in buttons:
		var button: Button = buttons.get(i, "resume")
		button.pressed.connect(_pressed.bind(i))
		
func _pressed(i):
	if i == "resume":
		visible = false
		Globals.started = true
	elif i == "reset":
		visible = false
		EventBus.reload.emit()
		Globals.started = true
	elif i == "exit":
		visible = false
		Globals.started = false
		EventBus.level.emit(0)
		EventBus.reload.emit(true)
		get_parent().get_node("Menu").visible = true
