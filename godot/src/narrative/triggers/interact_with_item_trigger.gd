class_name InteractWithItemSceneTrigger extends SceneTrigger

@export var item: Types.Item


func _init() -> void:
	Events.interacted_with_item.connect(_on_interacted_with_item)
	

func _to_string() -> String:
	return "Interact with %s" % Types.item_key(item)
	

func _on_interacted_with_item(interacted_item: Types.Item) -> void:
	if interacted_item == item:
		trigger()
