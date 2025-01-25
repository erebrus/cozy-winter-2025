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
		requirement.text = r.get_name()
		requirement.button_pressed = r.is_met
		requirement.toggled.connect(_on_requirement_toggled.bind(r))
		r.status_changed.connect(_on_requirement_status_changed.bind(requirement))
		%Requirements.add_child(requirement)
	
	sequence.ready_changed.connect(func(x): %ReadyButton.button_pressed = x)
	

func _force_meet_requirement(requirement: SequenceRequirement) -> void:
	if not requirement.is_met:
		if requirement is CharacterPresentSequenceRequirement:
			if requirement.should_be_in_scene:
				Globals.cafe.seat_character(Narrative.character_by(requirement.character_id))
			else:
				Logger.warn("removing character from scene not implemented")
		if requirement is TitlePassedSequenceRequirement:
			Narrative.title_passed.emit(requirement.sequence_id)
		if requirement is FlagSetSequenceRequirement:
			Narrative.set_flag(requirement.flag, requirement.should_be_set)
	

func _on_requirement_status_changed(status: bool, node: CheckBox) -> void:
	node.button_pressed = status
	

func _on_requirement_toggled(toggled_on: bool, requirement: SequenceRequirement) -> void:
	if toggled_on:
		_force_meet_requirement(requirement)
	

func _on_finished_button_toggled(toggled_on):
	if toggled_on:
		Narrative.current_sequence = sequence
		Narrative.title_passed.emit(sequence.id)
		sequence.finish()
	

func _on_ready_button_toggled(toggled_on):
	if toggled_on:
		for requirement in sequence.requirements:
			_force_meet_requirement(requirement)
		
	else:
		sequence.is_ready = sequence._check_ready()
		%ReadyButton.button_pressed = sequence.is_ready
