extends Surface


func _input(event: InputEvent) -> void:
	if has_mouse and Input.is_action_just_pressed("left_click"):
		Events.start_crafting.emit()
		
