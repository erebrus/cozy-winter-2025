class_name FlagSetSceneRequirement extends SceneRequirement

var flag: String
var should_be_set: bool


func _init(id: String, flag_set: bool) -> void:
	flag = id
	should_be_set = flag_set
	
	if should_be_set:
		is_met = Story.flags.has(flag) and Story.flags[flag]
	else:
		is_met = not Story.flags.has(flag) or not Story.flags[flag]
	
	Story.flag_updated.connect(_on_flag_updated)
	

func _on_flag_updated(updated_flag: String, value: bool) -> void:
	if updated_flag == flag:
		is_met = value == should_be_set
	

func get_name() -> String:
	return "%s=%s" % [flag, should_be_set]
	
