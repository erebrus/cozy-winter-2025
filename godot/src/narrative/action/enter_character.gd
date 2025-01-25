class_name EnterNPCSequenceAction extends SequenceAction

@export var character_id: Types.NPC

var character: Character

func setup() -> void:
	super.setup()
	character = Narrative.character_by(character_id)
	

func execute() -> void:
	Globals.cafe.seat_character(character)
	
