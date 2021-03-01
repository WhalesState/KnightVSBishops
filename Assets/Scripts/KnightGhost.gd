extends Node2D

onready var game = get_node('/root/Game')
onready var tween = get_node('Tween')
onready var spr = get_node('Sprite')


func _ready() -> void:
	tween.interpolate_property(spr, "self_modulate", spr.self_modulate, Color8(255,255,255,0), 0.3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, 'tween_completed')
	game.remove_child(self)
	queue_free()
