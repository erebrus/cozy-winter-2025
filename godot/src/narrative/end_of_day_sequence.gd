class_name EndOfDaySequence extends StorySequence

func setup() -> void:
	super.setup()
	triggered.connect(_end_day)
	actions.append(NextDaySequenceAction.new())
	

func _end_day() -> void:
	for character in Narrative.characters.values():
		character.leave()
		
