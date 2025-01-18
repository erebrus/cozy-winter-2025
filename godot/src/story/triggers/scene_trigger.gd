class_name SceneTrigger extends Resource

signal triggered


func trigger() -> void:
	triggered.emit()
	
