class_name TitlePassedSceneRequirement extends SceneRequirement

var scene_id: String


func _init(id: String) -> void:
	scene_id = id
	Story.title_passed.connect(_on_title_passed)
	

func _on_title_passed(title: String) -> void:
	if title == scene_id: 
		is_met = true


func get_name() -> String:
	return "%s passed" % scene_id
	
