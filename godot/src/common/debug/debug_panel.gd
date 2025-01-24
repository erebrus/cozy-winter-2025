extends PanelContainer

@export var StorySequenceInfoScene: PackedScene


@onready var sequence_category: OptionButton = %SequenceCategory
@onready var sequence_list: ItemList = %SequenceList
@onready var sequence_info: MarginContainer = %SequenceInfo

func _ready() -> void:
	hide()
	 

func _input(event: InputEvent) -> void:
	if Debug.debug_build and event.is_action_pressed("debug"):
		if visible:
			hide()
		else:
			open()
	

func open() -> void:
	_show_sequences(sequence_category.selected)
	show()
	

func _show_sequences(category: int) -> void:
	var sequences: Array[StorySequence]
	match category:
		0:
			sequences = Narrative.sequences
		1:
			sequences = Narrative.ready_sequences
	sequence_list.clear()
	for sequence in sequences:
		sequence_list.add_item(sequence.id, null, true)
	

func _on_music_tension_toggle_pressed() -> void:
	if Globals.music_manager.current_game_music_id==Types.GameMusic.HARD:
		Globals.music_manager.change_game_music_to(Types.GameMusic.EASY)
	else:
		Globals.music_manager.change_game_music_to(Globals.music_manager.current_game_music_id+1)
	

func _on_game_over_pressed():
	Globals.do_lose()
	

func _on_win_game_pressed():
	Globals.do_win()
	

func _on_sequence_category_item_selected(index):
	_show_sequences(index)


func _on_sequence_list_item_selected(index):
	for child in sequence_info.get_children():
		child.queue_free()
	var sequence_id = sequence_list.get_item_text(index)
	var sequence = StorySequenceInfoScene.instantiate()
	sequence.sequence = Narrative.sequences_by_id[sequence_id]
	sequence_info.add_child(sequence)
