extends Marker2D

func seat_character():
	$StepsSfx.play.call_deferred()
	await $StepsSfx.finished

func is_free():
	for child in get_children():
		if child is Character: 
			return false
	return true
