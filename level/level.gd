extends Node2D

@export var level_name = ""
@export var spawn_position: Node2D

@export var objects = []
@export var environment_tilemap: TileMapLayer
@export var object_tilemap: TileMapLayer

@export var base_time = 60.0
@export var base_actions = 5
