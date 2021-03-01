extends Control
onready var game = get_node('/root/Game')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $GameMode.get_children():
		child.text = EG.game_mode
	$Lost.play()
	$Score/Text.text = "Score : %s" % game.get_score()
	$Score/Shadow.text = $Score/Text.text
	$AnimationPlayer.play('Lose')
	yield($AnimationPlayer, 'animation_finished')
	$AnimationPlayer.play('Press')
	$Restart.show()


func _on_Restart_pressed() -> void:
	$Panel.popup_centered()


func _on_Difficulty_pressed(difficulty: String) -> void:
	EG.game_mode = difficulty
	get_tree().reload_current_scene()
