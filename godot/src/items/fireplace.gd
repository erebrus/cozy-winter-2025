extends "res://src/items/item.gd"


@export var fire_lit: bool = true

@onready var timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	if fire_lit:
		lit_fire()
	

func lit_fire() -> void:
	fire_lit = true
	Narrative.set_flag("fire_lit", true)
	timer.start()
	

func fire_out() -> void:
	Logger.info("Fire out")
	fire_lit = false
	Narrative.set_flag("fire_lit", false)
	

func interact() -> void:
	lit_fire()
	super.interact()
	

func _on_timeout() -> void:
	fire_out()
	
