class_name InteractWithItemSequenceTrigger extends SequenceTrigger

@export var item: Types.Item


func setup() -> void:
	super.setup()
	Events.interacted_with_item.connect(_on_interacted_with_item)
	

func _to_string() -> String:
	return "Interact with %s" % Types.item_key(item)
	

func _on_interacted_with_item(interacted_item: Types.Item) -> void:
	if interacted_item == item:
		trigger()
