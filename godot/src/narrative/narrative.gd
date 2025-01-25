extends Node

signal day_started

signal flag_updated(flag: String, value: bool)
signal title_passed(sequence_id: String)


@export var NPC: Characters
@export var sequences: Array[StorySequence]


var flags: Dictionary # Dictionary[String, bool]
var characters: Dictionary # [Types.NPC, Character]
var sequences_by_id: Dictionary # [String, StorySequence]

var ready_sequences: Array[StorySequence]
var current_sequence: StorySequence

var current_day:= 0


func _ready() -> void:
	_init_characters()
	_init_sequences()
	DialogueManager.passed_title.connect(_on_title_passed)
	

func character_by(id: Types.NPC) -> Character:
	assert(characters.has(id), "Resource for NPC %s not configured" % [Types.npc_key(id)])
	return characters[id]
	

func set_flag(flag: String, value: bool) -> void:
	flags[flag] = value
	flag_updated.emit(flag, value)
	

func next_day() -> void:
	current_day += 1
	day_started.emit()
	

func _init_characters() -> void:
	for i in Types.NPC.keys():
		var npc = NPC.get(i) as Character
		assert(npc != null, "Resource for NPC %s not configured" % [i])
		npc.id = Types.NPC[i]
		characters[npc.id] = npc
	

func _init_sequences() -> void:
	for sequence in sequences:
		sequence.setup()
		
		assert(not sequences_by_id.has(sequence.id), "Duplicate sequence %s" % sequence.id)
		sequences_by_id[sequence.id] = sequence
		sequence.ready_changed.connect(_on_sequence_ready_changed.bind(sequence))
		sequence.triggered.connect(_on_sequence_triggered.bind(sequence))
	

func _on_sequence_ready_changed(is_ready: bool, sequence: StorySequence) -> void:
	if is_ready:
		ready_sequences.append(sequence)
	else:
		ready_sequences.erase(sequence)
	

func _on_sequence_triggered(sequence: StorySequence) -> void:
	current_sequence = sequence
	DialogueManager.show_dialogue_balloon(sequence.dialogue, sequence.start_title)
	await DialogueManager.dialogue_ended
	sequence.finish()
	
	if not sequence.repeat:
		ready_sequences.erase(sequence)
	

func _on_title_passed(title: String): 
	if Globals.in_game:
		title_passed.emit("%s:%s" % [current_sequence.story_id, title])
	
