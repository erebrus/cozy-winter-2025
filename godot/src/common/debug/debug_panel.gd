extends PanelContainer

@export var StorySceneInfoScene: PackedScene


@onready var scene_category: OptionButton = %SceneCategory
@onready var scene_list: ItemList = %SceneList
@onready var scene_info: MarginContainer = %SceneInfo

func _ready() -> void:
	hide()
	 

func _input(event: InputEvent) -> void:
	if Debug.debug_build and event.is_action_pressed("debug"):
		if visible:
			hide()
		else:
			open()
	

func open() -> void:
	_show_scenes(scene_category.selected)
	show()
	

func _show_scenes(category: int) -> void:
	var scenes: Array[StoryScene]
	match category:
		0:
			scenes = Narrative.scenes
		1:
			scenes = Narrative.ready_scenes
	scene_list.clear()
	for scene in scenes:
		scene_list.add_item(scene.id, null, true)
	

func _on_music_tension_toggle_pressed() -> void:
	if Globals.music_manager.current_game_music_id==Types.GameMusic.HARD:
		Globals.music_manager.change_game_music_to(Types.GameMusic.EASY)
	else:
		Globals.music_manager.change_game_music_to(Globals.music_manager.current_game_music_id+1)
	

func _on_game_over_pressed():
	Globals.do_lose()
	

func _on_win_game_pressed():
	Globals.do_win()
	

func _on_scene_category_item_selected(index):
	_show_scenes(index)


func _on_scene_list_item_selected(index):
	for child in scene_info.get_children():
		child.queue_free()
	var scene_id = scene_list.get_item_text(index)
	var scene = StorySceneInfoScene.instantiate()
	scene.scene = Narrative.scenes_by_id[scene_id]
	scene_info.add_child(scene)
