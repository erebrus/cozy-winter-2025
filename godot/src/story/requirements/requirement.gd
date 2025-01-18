class_name SceneRequirement extends RefCounted

signal status_changed(met: bool)


var is_met: bool:
	set(value):
		if value == is_met:
			return
		is_met = value
		status_changed.emit(is_met)
	
