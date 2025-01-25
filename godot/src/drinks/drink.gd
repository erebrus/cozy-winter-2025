class_name Drink extends RefCounted

var ingridients: Dictionary # [Types.NodeType, int] Quantity of each ingridient

func _to_string() -> String:
	return str(ingridients)
