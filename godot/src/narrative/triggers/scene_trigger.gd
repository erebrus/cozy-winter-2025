class_name SequenceTrigger extends Resource

signal triggered


func trigger() -> void:
	triggered.emit()
	
