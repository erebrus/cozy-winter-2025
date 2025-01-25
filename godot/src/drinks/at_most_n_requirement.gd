class_name AtMostNDrinkRequirement extends DrinkRequirement

@export var type: Types.NodeType
@export var quantity: int = 0

func is_met_by(drink: Drink) -> bool:
	if drink.ingridients.has(type):
		return drink.ingridients[type] <= quantity
	return true
