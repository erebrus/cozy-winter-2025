class_name StoryScene extends Resource


signal ready_changed(value: bool)
signal triggered


@export var story_line: StoryLine
@export var start_title: String
@export var trigger: SceneTrigger
@export var repeat: bool

@export_category("Requirements")
@export var require_passed_titles: Array[String]

@export var require_npcs_present: Array[Types.NPC]
@export var require_npcs_missing: Array[Types.NPC]

@export var require_flags_true: Array[String]
@export var require_flags_false: Array[String]


var id: String
var requirements: Array[SceneRequirement]

var is_ready: bool = false:
	set(value):
		if value == is_ready:
			return
		is_ready = value
		ready_changed.emit(is_ready)
	

var has_played: bool


func setup() -> void:
	assert(not story_line.scenes.has(start_title), "Duplicate scene for storyline %s and start %s" % [story_line.id, start_title])
	story_line.scenes[start_title] = self
	
	id = _get_scene_id(start_title)
	
	for npc_id in require_npcs_present:
		_add_requirement(CharacterPresentSceneRequirement.new(npc_id, true))
		
	for npc_id in require_npcs_missing:
		_add_requirement(CharacterPresentSceneRequirement.new(npc_id, false))
		
	for flag in require_flags_true:
		_add_requirement(FlagSetSceneRequirement.new(flag, true))
		
	for flag in require_flags_false:
		_add_requirement(FlagSetSceneRequirement.new(flag, false))
		
	for scene_id in require_passed_titles:
		_add_requirement(TitlePassedSceneRequirement.new(_get_scene_id(scene_id)))
	
	trigger.triggered.connect(_on_triggered)
	

func _add_requirement(r: SceneRequirement) -> void:
	r.status_changed.connect(_on_requirements_changed)
	requirements.append(r)
	

func _check_ready() -> bool:
	for r in requirements:
		if not r.is_met:
			return false
	return true
	

func _get_scene_id(scene_id: String) -> String:
	if scene_id.is_empty() or scene_id.contains(":"):
		return scene_id
	else:
		return "%s:%s" % [story_line.id, scene_id]
	

func _on_requirements_changed(_value: bool) -> void:
	if has_played and not repeat:
		return
	
	is_ready = _check_ready()
	 

func _on_triggered() -> void:
	if is_ready and (repeat or not has_played):
		Logger.info("Scene %s triggered" % id)
		triggered.emit()
	 
