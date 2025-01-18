class_name InteractWithNpcSceneTrigger extends SceneTrigger

@export var npc: Types.NPC


func _init() -> void:
	Events.interacted_with_npc.connect(_on_interacted_with_npc)
	

func _to_string() -> String:
	return "Interact with %s" % Types.npc_key(npc)
	

func _on_interacted_with_npc(interacted_npc: Types.NPC) -> void:
	if interacted_npc == npc:
		trigger()
