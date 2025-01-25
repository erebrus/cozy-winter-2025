class_name DrinkRequirement extends Resource

@export var failure_sequence: String

func is_met_by(drink: Drink) -> bool:
	return true
	
