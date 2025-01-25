extends PopupPanel

var inputs: Dictionary


func _ready():
	for i in Types.NodeType.values():
		var label = Label.new()
		label.text = Types.NodeType.keys()[i]
		%Ingridients.add_child(label)
		
		var input = SpinBox.new()
		%Ingridients.add_child(input)
		inputs[i] = input
	

func _on_button_pressed():
	var drink = Drink.new()
	for i in Types.NodeType.values():
		drink.ingridients[i] = inputs[i].value
	Events.drink_completed.emit(drink)
	hide()
