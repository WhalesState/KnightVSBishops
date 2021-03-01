extends Area2D

onready var button = $Button
onready var knight = get_node('/root/Game/Knight')
onready var game =  get_node('/root/Game')
onready var black_tile = load('res://Assets/Sprites/BlackTile.png')
onready var white_tile = load('res://Assets/Sprites/WhiteTile.png')

var tile_pos : Vector2 setget , get_tile_pos
var free = true setget set_free , get_free
var enemy = null setget set_enemy, get_enemy

func _ready() -> void:
	tile_pos = position / 32
	if (int(tile_pos.x) % 2 == 0 && int(tile_pos.y) % 2 != 0) || (int(tile_pos.x) % 2 != 0 && int(tile_pos.y) % 2 == 0) :
		button.normal = white_tile
	else:
		button.normal = black_tile

func _on_TouchScreenButton_pressed() -> void:
	if game.player_turn:
		if knight.tween_finished:
			if (tile_pos-knight.get_pos()).abs() == Vector2(1, 2) || (tile_pos-knight.get_pos()).abs() == Vector2(2, 1):
				knight.set_pos(tile_pos)

func set_free(b:bool):
	free = b
func get_free():
	return free
	
func get_tile_pos():
	return tile_pos

func set_enemy(o:Object):
	enemy = o
func get_enemy():
	return enemy
