extends Node2D

@export var player: CharacterBody2D

var timer = 0.0
var actions = 0

var level_index = 0

var levels = [
	preload("res://level/level_0.tscn"),
	preload("res://level/level_1.tscn"),
	preload("res://level/level_2.tscn"),
	preload("res://level/level_3.tscn"),
	preload("res://level/level_4.tscn"),
	preload("res://level/level_5.tscn"),
	preload("res://level/level_6.tscn"),
	preload("res://level/level_16.tscn"),
]

var current_data = {
	"level": null,
	"objects": [],
	"tilemap": {
		"environment": null,
		"object": null
	},
	"base_time": 0.0,
	"base_actions": 0,
	"spawn_position": Vector2(0, 0),
}

var save_data = {
	"saved_time": 0.0,
	"saved_actions": 0,
}

# var current_level: Node2D
# var current_objects = []
# var current_tilemap: TileMapLayer

# var current_time = 0.0
# var current_actions = 0

# TODO: entity spawner

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		reload()

func _ready() -> void:
	load_level(0)
	
	EventBus.action.connect(func(_val): 
		actions -= 1
		
		EventBus.hud.emit("action", actions)
		if actions < 0: # dead, reset
			reload()
		)
	
	EventBus.reload.connect(reload)
	EventBus.level.connect(load_level)

func load_level(index: int, bonus = true):
	
	if current_data["level"]:
		current_data["level"].queue_free()
		current_data["level"] = null
	
	var lvl = levels[index].instantiate()
	add_child(lvl)
	
	if level_index != index:
		var lv_name = player.get_node("LevelName")
		lv_name.text = str("|", lvl["level_name"])
		lv_name.modulate.a = 1.0
		
		var tween = create_tween()
		tween.tween_property(lv_name, "modulate:a", 0.0, 2).set_ease(Tween.EASE_OUT)
		
	
	level_index = index
	
	current_data["tilemap"]["environment"] = lvl["environment_tilemap"]
	current_data["tilemap"]["object"] = lvl["object_tilemap"]
	
	current_data["objects"] = lvl["objects"]
	current_data["base_time"] = lvl["base_time"]
	current_data["base_actions"] = lvl["base_actions"]
	current_data["spawn_position"] = lvl["spawn_position"].global_position
	current_data["level"] = lvl
	
#	for i in current_data:
#		if i != "level":
#			i = lvl[i]

	var bonus_time = clamp(Globals.timer/10.0, 0, 10.0) if bonus else 0
	var bonus_actions = clamp(actions, 0, 2) if bonus else 0
	
	timer = current_data["base_time"] + bonus_time
	actions = current_data["base_actions"] + bonus_actions
	
	if bonus_time > 0.0: EventBus.log_text.emit(str("+", snapped(bonus_time, 0.1), "s"))
	if bonus_actions > 0: EventBus.log_text.emit(str("+", bonus_actions, " actions"))
	
	save_data["saved_actions"] = actions
	save_data["saved_time"] = timer
	
	EventBus.hud.emit("action", actions)
	EventBus.hud.emit("timer", timer)
	
	reload()
	
func save():
	pass

func reload(clean = false):
	player.die(current_data["spawn_position"])
	player.buffer()
	
	if clean: 
		player.target_velocity = Vector2.ZERO
		player.current_velocity = Vector2.ZERO
	
	actions = save_data["saved_actions"]
	timer = save_data["saved_time"]
	
	EventBus.hud.emit("action", actions)
	EventBus.hud.emit("timer", timer)
	
	$Camera/Reset.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property($Camera/Reset, "modulate:a", 0.0, .2).set_ease(Tween.EASE_OUT)


# TODO: check if entities in floaty
# TODO check if player in hazard

var level_buffer = false
func _process(_delta: float) -> void:
	var bgm = $bgm
	if Globals.started:
		if !bgm.playing: 
			bgm.play()
			bgm.volume_db = Globals.volume
	else:
		if bgm.playing: 
			bgm.stop()
	
	
	if current_data["tilemap"]: 
		if current_data["objects"].size() > 0:
			for obj: RigidBody2D in current_data["objects"]:
				var floating = get_tile_property(current_data["tilemap"]["environment"], obj.global_position, "Float")
				if floating and obj is RigidBody2D:
					obj.apply_force(Vector2(0, -400))
		
		var player_floating = get_tile_property(current_data["tilemap"]["environment"], player.global_position, "Float")
		player["states"]["is_submerged"] = player_floating
		
		var hazardous = get_tile_property(current_data["tilemap"]["object"], player.global_position, "Hazard")
		if hazardous and player.iframes <= 0: 
			reload()
		
		var next = get_tile_property(current_data["tilemap"]["object"], player.global_position, "Next")
		if next and not level_buffer: 
			enter_level(level_index + 1)
			
func enter_level(index: int):
	if index >= levels.size(): Datastore.save_time(Globals.current_time)
	
	index = (index) % levels.size()
	print(str(index))
	level_buffer = true
	load_level(index)
	await get_tree().create_timer(.1).timeout
	level_buffer = false


func get_tile_property(tilemap, global_pos: Vector2, property: String):
	if not tilemap: return
	
	var current_tilemap = tilemap # current_data["tilemap"]
	var local_pos = current_tilemap.to_local(global_pos)

	var cell_coords: Vector2i = current_tilemap.local_to_map(local_pos)
	
	var tile_data: TileData = current_tilemap.get_cell_tile_data(cell_coords)
	
	if tile_data:
		var prop = tile_data.get_custom_data(property)
		return prop or null
	else:
#		print("No tile at position: ", cell_coords)
		return null
