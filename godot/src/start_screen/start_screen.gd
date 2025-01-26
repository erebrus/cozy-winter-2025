extends ColorRect


func _ready() -> void:
	Globals.in_game=false
	
	

func _on_volume_changed(_value: float) -> void:
	if not is_node_ready():
		return
	
	Globals.ui_sfx.click_sfx.play()
	


func _on_start_button_pressed() -> void:
	Globals.start_game()
	
