extends Node2D

@export var player: CharacterBody2D


var levels = [
	preload("res://level/level_0.tscn"),
]

var current_level
var current_tilemap

# TODO: entity spawner

# TODO: check if entities in floaty
# TODO check if player in hazard
func _process(delta: float) -> void:
	pass


func get_tile_property(global_pos: Vector2, property: String):
	if not current_tilemap: return
	var local_pos = current_tilemap.to_local(global_pos)

	var cell_coords: Vector2i = current_tilemap.local_to_map(local_pos)
	
	var tile_data: TileData = current_tilemap.get_cell_tile_data(0, cell_coords)
	
	if tile_data:
		var prop = tile_data.get_custom_data(property)
		return prop or null
	else:
		return null
		print("No tile at position: ", cell_coords)
