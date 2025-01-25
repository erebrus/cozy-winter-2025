class_name StorySequence extends Resource


signal ready_changed(value: bool)
signal triggered
signal finished


@export var dialogue: DialogueResource

@export var start_title: String
@export var trigger: SequenceTrigger
@export var repeat: bool

@export var actions: Array[SequenceAction]


@export_category("Requirements")
@export var require_passed_titles: Array[String]

@export var require_npcs_present: Array[Types.NPC]
@export var require_npcs_missing: Array[Types.NPC]

@export var require_flags_true: Array[String]
@export var require_flags_false: Array[String]


var story_id: String
var id: String
var requirements: Array[SequenceRequirement]

var is_ready: bool = false:
	set(value):
		if value == is_ready:
			return
		is_ready = value
		ready_changed.emit(is_ready)
	

var has_played: bool


func setup() -> void:
	story_id = dialogue.resource_path.get_basename().get_file()
	
	id = _get_sequence_id(start_title)
	
	for npc_id in require_npcs_present:
		_add_requirement(CharacterPresentSequenceRequirement.new(npc_id, true))
		
	for npc_id in require_npcs_missing:
		_add_requirement(CharacterPresentSequenceRequirement.new(npc_id, false))
		
	for flag in require_flags_true:
		_add_requirement(FlagSetSequenceRequirement.new(flag, true))
		
	for flag in require_flags_false:
		_add_requirement(FlagSetSequenceRequirement.new(flag, false))
		
	for sequence_id in require_passed_titles:
		_add_requirement(TitlePassedSequenceRequirement.new(_get_sequence_id(sequence_id)))
	
	trigger.setup()
	trigger.triggered.connect(_on_triggered)
	
	for action in actions:
		action.setup()
	
	is_ready = _check_ready()
	

func finish() -> void:
	Logger.info("Sequence %s finished playing" % id)
	has_played = true
	for action in actions:
		action.execute()
	finished.emit()
	

func _add_requirement(r: SequenceRequirement) -> void:
	r.status_changed.connect(_on_requirements_changed)
	requirements.append(r)
	

func _check_ready() -> bool:
	for r in requirements:
		if not r.is_met:
			return false
	return true
	

func _get_sequence_id(sequence_id: String) -> String:
	if sequence_id.is_empty() or sequence_id.contains(":"):
		return sequence_id
	else:
		return "%s:%s" % [story_id, sequence_id]
	

func _on_requirements_changed(_value: bool) -> void:
	if has_played and not repeat:
		return
	
	is_ready = _check_ready()
	 

func _on_triggered() -> void:
	if is_ready and (repeat or not has_played):
		Logger.info("Sequence %s triggered" % id)
		triggered.emit()
	 
