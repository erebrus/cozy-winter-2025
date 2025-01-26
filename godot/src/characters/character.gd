class_name Character extends Area2D

signal character_entered
signal character_left

@export var id: Types.NPC
@export var character_name: String


var in_scene: bool = false:
	set(value):
		if value == in_scene:
			return
		in_scene = value
		if in_scene:
			character_entered.emit()
		else:
			character_left.emit()
	

func leave() -> void:
	if in_scene:
		Logger.info("%s leaves the cafe" % character_name)
		reparent(Narrative.character_container)
		in_scene = false
	

func interact() -> void:
	Logger.info("Interacted with %s" % Types.npc_key(id))
	Events.interacted_with_npc.emit(id)
	

func _input_event(_viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interact()
