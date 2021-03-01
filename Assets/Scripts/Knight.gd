extends Node2D

onready var anim_player = get_node('/root/Game/AnimationPlayer') as AnimationPlayer
onready var shock = get_node('/root/Game/CanvasLayer/Shock') as ColorRect
onready var board_node = get_node('../Board') as Node2D
onready var game = get_node('/root/Game') as Control
onready var tween = get_node('Tween') as Tween

var combo := false
var tween_finished := true
var board := {}
var pos := Vector2(4, 4) setget set_pos, get_pos

func _ready() -> void:
	board = board_node.get_board()

func set_pos(v:Vector2):
	if board.has(str(v)):
		var tile = board[str(v)]
		tween_finished = false
		tween.interpolate_property(self, 'position', position, tile.get_global_position(), 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		game.start_ghost()
		yield(tween, 'tween_completed')
		game.stop_ghost()
		tween_finished = true
		board[str(pos)].set_free(true)
		pos = v
		if !tile.get_free():
			shock.material.set_shader_param('center', Vector2( (tile.get_global_position().x + 16) /360 , ( 360 - (tile.get_global_position().y + 16)) / 360))
			anim_player.play('shockwave')
			game.enemies.remove_child(tile.get_enemy())
			tile.get_enemy().queue_free()
			tile.set_enemy(null)
			game.set_enemies_count()
			game.get_free_tiles()
			game.eat.pitch_scale = randf() * 0.5 + 1.0
			game.eat.play()
			if !combo:
				combo = true
			else:
				game.score_multiplier += 1
			game.set_score(1 if EG.game_mode == "Easy" else 2)
		else:
			game.hit.pitch_scale = randf() * 0.5 + 0.7
			game.hit.play()
			tile.set_free(false)
			game.set_moves_left(-1)
			game.get_free_tiles()
			if combo:
				combo = false
				game.score_multiplier = 1
			game.set_score(0)
		
func get_pos():
	return pos

