class_name TitlePassedSequenceRequirement extends SequenceRequirement

var sequence_id: String


func _init(id: String) -> void:
	sequence_id = id
	Narrative.title_passed.connect(_on_title_passed)
	

func _on_title_passed(title: String) -> void:
	if title == sequence_id: 
		is_met = true


func get_name() -> String:
	return "%s passed" % sequence_id
	
