extends Area2D


@export var id: Types.Item


func interact() -> void:
	Logger.info("Interacted with %s" % Types.item_key(id))
	Events.interacted_with_item.emit(id)
	

func _input_event(_viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interact()
