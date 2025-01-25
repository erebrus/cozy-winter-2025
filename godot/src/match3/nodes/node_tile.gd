extends Area2D 
class_name NodeTile

@export var click_area_radius:=48.0
@export var type:=Types.NodeType.COFFEE
const GRAVITY=1000
@onready var sprite: Sprite2D = $Sprite2D

var cell:=Vector2i(-1,-1)
var board:Board
var vy:=0.0

func _ready() -> void:
	($CollisionShape2D.shape as CircleShape2D).radius=click_area_radius
	
func _physics_process(delta: float) -> void:
	var target := board.map_to_world(cell)
	var dy = target.y-position.y
				
	if dy != 0:
		vy+=sign(dy)*GRAVITY*delta
		if abs(dy)<abs(vy*delta):
			Logger.trace("Snapping- dy=%2f vy=%2f cell=%s position=%s" % [dy, vy, cell, position])
			position = target
			vy=0
		else:
			position.y+=vy*delta
		
	#board.world_to_map()
	#if not rc.is_colliding():
		#vy+=GRAVITY*delta
	#else:
func is_in_right_cell()->bool:	
	return board.world_to_map(position).y==cell.y
func _on_mouse_entered() -> void:
	Events.node_entered.emit(self)


func _on_mouse_exited() -> void:
	Events.node_exited.emit(self)
	
func destroy():
	#TODO do explosion
	queue_free()
