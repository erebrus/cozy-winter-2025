class_name Cafe extends Node


var seats: Array[Marker2D]

@onready var door_sfx := %DoorSfx
@onready var cups_sfx := %CupsSfx


func _ready() -> void:
	Globals.cafe = self
	Narrative.next_day()
	
	for seat in %Seats.get_children():
		if seat is Marker2D:
			seats.append(seat)
	
	

func seat_character(character: Character) -> void:
	Logger.info("%s enters the cafe" % character.character_name)
	var seat = _find_free_seat(character)
	character.visible = false
	character.reparent(seat)
	character.position = Vector2.ZERO
	
	door_sfx.play()
	await get_tree().create_timer(0.2).timeout
	await seat.seat_character()
	character.visible = true
	character.in_scene = true
	

func _find_free_seat(_character: Character) -> Marker2D:
	# TODO: find free seat -> where should each character sit? -> maybe each character has a favorite spot, and we find the closest free seat to that spot
	var preferred_seat = int(ceil(seats.size() / 2.0)) # middle seat
	
	for i in range(0, seats.size()):
		var left_seat = max(0, preferred_seat - i)
		var right_seat = min(preferred_seat + i, seats.size() - 1)
		if seats[left_seat].is_free():
			return seats[left_seat]
		if seats[right_seat].is_free():
			return seats[right_seat]
		
	push_error("There are no free seats")
	return null
	

func _is_seat_occupied(seat: Marker2D) -> bool:
	return seat.get_child_count() > 0
	


func _on_cups_timer_timeout():
	cups_sfx.play()
