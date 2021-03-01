extends Node2D

onready var tile = load('res://Assets/Scenes/Packed/Tile.tscn')

var board_size = Vector2(8,8)
var screen = Vector2(360, 360)

var board = {} setget , get_board
var free_tiles = [] setget , get_free_tiles

func _ready() -> void:
	position = (screen/2) - ((board_size*32)/2)
	for i in range(board_size.y):
		for j in range(board_size.x):
			var child = tile.instance()
			child.position = Vector2(j * 32 , i * 32)
			child.name = str(child.position / 32)
			board[child.name] = child
			add_child(child)

func get_free_tiles():
	free_tiles.clear()
	for child in get_children():
		if child.get_free():
			free_tiles.append(child.name)
	return free_tiles

func get_board():
	return board
