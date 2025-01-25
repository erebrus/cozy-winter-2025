class_name SequenceTrigger extends Resource

signal triggered


func setup() -> void:
	pass
	

func trigger() -> void:
	triggered.emit()
	
