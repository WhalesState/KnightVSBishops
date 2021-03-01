extends Node2D

onready var popup_panel = get_node("Panel") as PopupPanel
onready var game_scene = preload("res://Assets/Scenes/Game.tscn")


func _ready() -> void:
	$AnimationPlayer.play('Start')

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'Start':
		$StartButton.show()
		$AnimationPlayer.play('Fade')

func _input(event: InputEvent) -> void:
	if !event is InputEventMouseButton:
		return
	if event.is_pressed():
		$AnimationPlayer.seek(5.9)

func _on_StartButton_pressed() -> void:
	popup_panel.popup_centered()

func _on_Difficulty_pressed(difficulty : String) -> void:
	EG.game_mode = difficulty
	get_tree().change_scene_to(game_scene)
	
	
