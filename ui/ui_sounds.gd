extends CanvasLayer

@onready var menu = {
	"pause": $Pause,
	"menu": $Menu,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button: Button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(func(): SoundManager.play_sound("select", true))
		button.mouse_entered.connect(func(): SoundManager.play_sound("tick", true))
	
	EventBus.open_menu.connect(_open_menu)
	
func _open_menu(type):
	for i in menu:
		if type != i: menu[type].visible = false
		else: 
			menu[type].visible = true
			Globals.started = false
