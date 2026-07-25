extends Node

var sounds = {
	# SFX #
	"pong": preload("res://assets/sounds/pong.ogg"),
	"ting": preload("res://assets/sounds/ting.ogg"),
	"thump": preload("res://assets/sounds/thump.ogg"),
	
	# UI #
	"tick": preload("res://assets/sounds/tick.ogg"),
	"select": preload("res://assets/sounds/select.ogg")
}

func play_sound(type: String = "ping"):
	if not Globals.started: return
	
	var plr = AudioStreamPlayer2D.new()
	add_child(plr)
	
	plr.stream = sounds.get(type)
	plr.play()
	
	plr.finished.connect(func(): plr.queue_free())
