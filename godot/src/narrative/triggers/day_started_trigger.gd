class_name DayStartedSequenceTrigger extends SequenceTrigger


@export var day: int

func setup() -> void:
	super.setup()
	Narrative.day_started.connect(_on_day_started)
	

func _to_string() -> String:
	return "Start Day %s" % day
	

func _on_day_started() -> void:
	if Narrative.current_day == day:
		trigger()
