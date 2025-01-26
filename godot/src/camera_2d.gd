extends Camera2D

func _ready():
	await get_tree().create_timer(0.1).timeout
	position_smoothing_enabled = true
	

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	global_position.x = mouse_position.x
