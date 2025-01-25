class_name Cafe extends Node


var seats: Array[Marker2D]


func _ready() -> void:
	Globals.cafe = self
	Narrative.next_day()
	
	for seat in %Seats.get_children():
		if seat is Marker2D:
			seats.append(seat)
	

func seat_character(character: Character) -> void:
	Logger.info("%s enters the cafe" % character.character_name)
	character.reparent(_find_free_seat(character))
	character.position = Vector2.ZERO
	character.in_scene = true
	

func _find_free_seat(_character: Character) -> Marker2D:
	# TODO: find free seat -> where should each character sit? -> maybe each character has a favorite spot, and we find the closest free seat to that spot
	var preferred_seat = int(ceil(seats.size() / 2.0)) # middle seat
	
	for i in range(0, seats.size()):
		var left_seat = max(0, preferred_seat - i)
		var right_seat = min(preferred_seat + i, seats.size() - 1)
		if not _is_seat_occupied(seats[left_seat]):
			return seats[left_seat]
		if not _is_seat_occupied(seats[right_seat]):
			return seats[right_seat]
		
	push_error("There are no free seats")
	return null
	

func _is_seat_occupied(seat: Marker2D) -> bool:
	return seat.get_child_count() > 0
	
