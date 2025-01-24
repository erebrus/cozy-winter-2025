extends CharacterBody2D


@export var id: Types.NPC


var resource: Character


func _ready() -> void:
	resource = Narrative.character_by(id)
	resource.character_entered.emit()
	

func _exit_tree() -> void:
	resource.character_left.emit()
	

func interact() -> void:
	Logger.info("Interacted with %s" % Types.npc_key(id))
	Events.interacted_with_npc.emit(id)
	

func _input_event(_viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interact()
