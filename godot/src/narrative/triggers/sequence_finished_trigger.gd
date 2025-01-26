class_name SequenceFinishedSequenceTrigger extends SequenceTrigger


func setup() -> void:
	super.setup()
	for sequence in Narrative.sequences:
		sequence.finished.connect(trigger)
