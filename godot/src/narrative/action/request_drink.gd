class_name RequestDrinkSequenceAction extends SequenceAction

@export var request: DrinkRequest
@export var correct_sequence: String

var sequence: StorySequence


func execute() -> void:
	sequence = Narrative.current_sequence
	Events.drink_requested.emit(request)
	var drink = await Events.drink_completed
	
	for requirement in request.requirements:
		if not requirement.is_met_by(drink):
			_trigger_end_sequente(requirement.failure_sequence)
			return
	
	_trigger_end_sequente(correct_sequence)
	

func _trigger_end_sequente(id: String) -> void:
	if id == "":
		return
	
	var dialog = sequence.dialogue
	if dialog.titles.has(id):
		DialogueManager.show_dialogue_balloon(dialog, id)
	else:
		DialogueManager.show_dialogue_balloon(dialog, correct_sequence)
	
