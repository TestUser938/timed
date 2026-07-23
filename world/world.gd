extends Node2D

@export var player: CharacterBody2D
var timer = 0
var actions = 0

var levels = [
	preload("res://level/level_0.tscn"),
]

var current_level: Node2D
var current_objects = []
var current_tilemap: TileMapLayer

# TODO: entity spawner

func _ready() -> void:
	load_level(0)

func load_level(index: int):
	if current_level:
		current_level.queue_free()
		current_level = null
		
	var lvl = levels[0].instantiate()
	add_child(lvl)
	
	current_objects.clear()
	current_objects = lvl["objects"]
	
	current_level = lvl
	current_tilemap = lvl["tilemap"]


# TODO: check if entities in floaty
# TODO check if player in hazard
func _process(delta: float) -> void:
	if current_tilemap: 
		if current_objects.size() > 0:
			for obj: RigidBody2D in current_objects:
				var floating = get_tile_property(obj.global_position, "Float")
				if floating and obj is RigidBody2D:
					obj.apply_force(Vector2(0, -400))
		
		var player_floating = get_tile_property(player.global_position, "Float")
		player["states"]["is_submerged"] = player_floating
		
		var hazardous = get_tile_property(player.global_position, "Hazard")
		if hazardous: player.die()
	


func get_tile_property(global_pos: Vector2, property: String):
	if not current_tilemap: return
	var local_pos = current_tilemap.to_local(global_pos)

	var cell_coords: Vector2i = current_tilemap.local_to_map(local_pos)
	
	var tile_data: TileData = current_tilemap.get_cell_tile_data(cell_coords)
	
	if tile_data:
		var prop = tile_data.get_custom_data(property)
		return prop or null
	else:
		print("No tile at position: ", cell_coords)
		return null
