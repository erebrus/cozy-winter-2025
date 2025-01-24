class_name FlagSetSequenceRequirement extends SequenceRequirement

var flag: String
var should_be_set: bool


func _init(id: String, flag_set: bool) -> void:
	flag = id
	should_be_set = flag_set
	
	if should_be_set:
		is_met = Narrative.flags.has(flag) and Narrative.flags[flag]
	else:
		is_met = not Narrative.flags.has(flag) or not Narrative.flags[flag]
	
	Narrative.flag_updated.connect(_on_flag_updated)
	

func _on_flag_updated(updated_flag: String, value: bool) -> void:
	if updated_flag == flag:
		is_met = value == should_be_set
	

func get_name() -> String:
	return "%s=%s" % [flag, should_be_set]
	
