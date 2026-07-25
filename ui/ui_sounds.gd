extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button: Button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(func(): SoundManager.play_sound("select", true))
		button.mouse_entered.connect(func(): SoundManager.play_sound("tick", true))
		
		
		
