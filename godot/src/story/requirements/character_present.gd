class_name CharacterPresentSceneRequirement extends SceneRequirement

var character_id: Types.NPC

var should_be_in_scene: bool

func _init(id: Types.NPC, in_scene: bool) -> void:
	character_id = id
	should_be_in_scene = in_scene
	
	var character = Story.character_by(character_id)
	
	character.character_entered.connect(func(): is_met = should_be_in_scene)
	character.character_left.connect(func(): is_met = not should_be_in_scene)
	

func get_name() -> String:
	if should_be_in_scene:
		return "%s in scene" % Types.npc_key(character_id)
	else:
		return "%s not in scene" % Types.npc_key(character_id)
	
