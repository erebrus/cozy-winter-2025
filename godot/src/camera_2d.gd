extends Camera2D

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	global_position.x = mouse_position.x
