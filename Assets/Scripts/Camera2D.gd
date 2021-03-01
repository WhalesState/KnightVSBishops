extends Camera2D

onready var tween = get_node('Tween')

var amplitude = 0

func start(dur = 0.2, freq = 30, amp = 8) -> void:
	amplitude = amp
	$Duration.wait_time = dur
	$Frequency.wait_time = 1 / float(freq)
	$Duration.start()
	$Frequency.start()
	new_shake()


func new_shake() -> void:
	var rand = Vector2.ZERO
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	tween.interpolate_property(self, 'offset', offset, rand, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func reset() -> void:
	tween.interpolate_property(self, 'offset', offset, Vector2.ZERO, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Frequency_timeout() -> void:
	new_shake()

func _on_Duration_timeout() -> void:
	reset()
	$Frequency.stop()
