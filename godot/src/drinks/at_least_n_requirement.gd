class_name AtLeastNDrinkRequirement extends DrinkRequirement

@export var type: Types.NodeType
@export var quantity: int = 1


func is_met_by(drink: Drink) -> bool:
	if drink.ingridients.has(type):
		return drink.ingridients[type] >= quantity
	return false
