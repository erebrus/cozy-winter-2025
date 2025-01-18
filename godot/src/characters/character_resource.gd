class_name Character extends Resource

signal character_entered
signal character_left


var id: Types.NPC

@export var name: String

var in_scene: bool = false:
	set(value):
		if value == in_scene:
			return
		in_scene = value
		if in_scene:
			character_entered.emit()
		else:
			character_left.emit()
