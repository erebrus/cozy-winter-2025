class_name InteractWithNpcSequenceTrigger extends SequenceTrigger

@export var npc: Types.NPC
@export var give_drink_on: String


func setup() -> void:
	super.setup()
	Events.interacted_with_npc.connect(_on_interacted_with_npc)
	if not give_drink_on.is_empty():
		Narrative.title_passed.connect(_on_title_passed)
	
	

func _to_string() -> String:
	return "Interact with %s" % Types.npc_key(npc)
	

func _on_interacted_with_npc(interacted_npc: Types.NPC) -> void:
	if interacted_npc == npc:
		trigger()

func _on_title_passed(title: String) -> void:
	if title.ends_with(":%s" % give_drink_on):
		Narrative.character_by(npc).give_drink()
