extends PanelContainer


var scene: StoryScene

func _ready() -> void:
	%SceneIdLabel.text = scene.id
	%TriggerLabel.text = str(scene.trigger)
	%FinishedButton.button_pressed = scene.has_played
	%ReadyButton.button_pressed = scene.is_ready
	
	for child in %Requirements.get_children():
		child.queue_free()
		
	for r in scene.requirements:
		var requirement = CheckBox.new()
		requirement.disabled = true
		requirement.text = r.get_name()
		requirement.button_pressed = r.is_met
		%Requirements.add_child(requirement)
		
