extends Node


signal flag_updated(flag: String, value: bool)
signal title_passed(scene_id: String)


@export var NPC: Characters
@export var scenes: Array[StoryScene]


var flags: Dictionary # Dictionary[String, bool]
var characters: Dictionary # [Types.NPC, Character]
var scenes_by_id: Dictionary # [String, StoryScene]

var story_lines: Array[StoryLine]

var ready_scenes: Array[StoryScene]
var current_story: StoryLine


func _ready() -> void:
	_init_characters()
	_init_scenes()
	DialogueManager.passed_title.connect(func(title): title_passed.emit("%s:%s" % [current_story.id, title]))
	

func character_by(id: Types.NPC) -> Character:
	assert(characters.has(id), "Resource for NPC %s not configured" % [Types.npc_key(id)])
	return characters[id]
	

func set_flag(flag: String, value: bool) -> void:
	flags[flag] = value
	flag_updated.emit(flag, value)
	

func _init_characters() -> void:
	for i in Types.NPC.keys():
		var npc = NPC.get(i) as Character
		assert(npc != null, "Resource for NPC %s not configured" % [i])
		npc.id = Types.NPC[i]
		characters[npc.id] = npc
	

func _init_scenes() -> void:
	for scene in scenes:
		if not story_lines.has(scene.story_line):
			story_lines.append(scene.story_line)
		
		scene.setup()
		
		assert(not scenes_by_id.has(scene.id), "Duplicate scene %s" % scene.id)
		scenes_by_id[scene.id] = scene
		scene.ready_changed.connect(_on_scene_ready_changed.bind(scene))
		scene.triggered.connect(_on_scene_triggered.bind(scene))
	

func _on_scene_ready_changed(is_ready: bool, scene: StoryScene) -> void:
	if is_ready:
		ready_scenes.append(scene)
	else:
		ready_scenes.erase(scene)
	

func _on_scene_triggered(scene: StoryScene) -> void:
	current_story = scene.story_line
	DialogueManager.show_dialogue_balloon(scene.story_line.dialogue, scene.start_title)
	await DialogueManager.dialogue_ended
	scene.has_played = true
	
	if not scene.repeat:
		ready_scenes.erase(scene)
