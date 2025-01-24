extends PanelContainer


var sequence: StorySequence

func _ready() -> void:
	%IdLabel.text = sequence.id
	%TriggerLabel.text = str(sequence.trigger)
	%FinishedButton.button_pressed = sequence.has_played
	%ReadyButton.button_pressed = sequence.is_ready
	
	for child in %Requirements.get_children():
		child.queue_free()
		
	for r in sequence.requirements:
		var requirement = CheckBox.new()
		requirement.disabled = true
		requirement.text = r.get_name()
		requirement.button_pressed = r.is_met
		%Requirements.add_child(requirement)
		
