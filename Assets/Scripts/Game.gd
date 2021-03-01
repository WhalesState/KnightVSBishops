extends Control

onready var bishop = preload('res://Assets/Scenes/Packed/Bishop.tscn')
onready var knight_ghost = preload('res://Assets/Scenes/Packed/KnightGhost.tscn')
onready var lost = preload('res://Assets/Scenes/Packed/Lost.tscn')

onready var hit = get_node('Hit') as AudioStreamPlayer
onready var eat = get_node('Eat') as AudioStreamPlayer
onready var anim_player = get_node('AnimationPlayer') as AnimationPlayer
onready var ghost_timer = get_node('Ghost') as Timer
onready var score_label = get_node('Score') as Control
onready var label = get_node('Label') as Control
onready var board_node = get_node('Board') as Node2D
onready var knight = get_node('Knight') as Node2D
onready var enemies = get_node('Enemies') as Node2D
onready var cam = get_node('Camera2D') as Camera2D 
onready var timer = get_node('Timer') as Timer

var score_multiplier := 1
var board = {}
var enemies_count = 0

var player_turn = false setget set_player_turn
var moves_left = 0 setget set_moves_left , get_moves_left
var free_tiles = [] setget, get_free_tiles
var computer_turn = true setget set_computer_turn
var score = 0 setget set_score, get_score

func _on_Timer_timeout() -> void:
	set_moves_left(-1)
	if enemies_count < 10:
		timer.start(5)

func _ready() -> void:
	if EG.game_mode == "Hard":
		$TimerLabel.show()
		timer.start()
	else:
		$TimerLabel.hide()
	randomize()
	board = board_node.get_board()
	knight.position = board['(4, 4)'].get_global_position()
	board['(4, 4)'].set_free(false)
	get_free_tiles()
	set_computer_turn(true)
	set_enemies_count()
	set_score(0)

func set_player_turn(b:bool):
	player_turn = b
	set_computer_turn(false if b else true)

func _physics_process(_delta: float) -> void:
	if EG.game_mode == "Hard":
		for child in $TimerLabel.get_children():
			child.text = "Time Left : %s" % stepify(timer.time_left ,0.1)

func set_moves_left(i:int):
	moves_left += i
	if moves_left == 0:
		set_player_turn(false)
	else:
		set_player_turn(true)

func get_moves_left():
	return moves_left

func get_free_tiles():
	free_tiles.clear()
	for tile in board.values():
		if tile.get_free():
			free_tiles.append(tile)
	return free_tiles

func set_computer_turn(b:bool):
	if b:
		var tiles = get_free_tiles()
		var tile = tiles[randi() % tiles.size() - 1]
		var enemy = bishop.instance()
		enemy.position = tile.get_global_position()
		tile.set_enemy(enemy)
		tile.set_free(false)
		enemies.add_child(enemy)
		enemies_count = enemies.get_child_count()
		set_enemies_count()
		if enemies_count >= 10:
			cam.start()
			$block.show()
			timer.stop()
			$CanvasLayer.add_child(lost.instance())
		else:
			set_moves_left(1)
	else:
		computer_turn = false

func set_enemies_count():
	enemies_count = enemies.get_child_count()
	for child in label.get_children():
		child.text = "Bishops Count : %s" % enemies_count
	
func set_score(i:int):
	score += i * score_multiplier
	for child in score_label.get_children():
		if score_multiplier > 1:
			child.text = "Score : %s X %s" % [score, score_multiplier]
		else:
			child.text = "Score : %s" % score

func get_score():
	return score

func start_ghost():
	ghost_timer.start()

func stop_ghost():
	ghost_timer.stop()

func _on_Ghost_timeout() -> void:
	var inst = knight_ghost.instance()
	inst.position = knight.get_global_position()
	add_child(inst)
