extends Node2D
class_name Board

var NodeScenes = [
	preload("res://src/match3/nodes/coffee_node.tscn"),
	preload("res://src/match3/nodes/tea_node.tscn"),
	preload("res://src/match3/nodes/cocoa_node.tscn"),
	preload("res://src/match3/nodes/milk_node.tscn"),
	preload("res://src/match3/nodes/soy_milk_node.tscn"),
	preload("res://src/match3/nodes/almond_milk_node.tscn"),
	preload("res://src/match3/nodes/white_sugar_node.tscn"),
	preload("res://src/match3/nodes/brown_sugar_node.tscn"),
	preload("res://src/match3/nodes/honey_node.tscn"),
	preload("res://src/match3/nodes/love_node.tscn"),
	preload("res://src/match3/nodes/connector_node.tscn")
]

@export var board_size:=Vector2i(6,6)
@export var cell_size:=64
@export var back_tile_texture:Texture
@export var back_tile_scale:float=1.0
@onready var back: Node2D = $Back
@onready var nodes: Polygon2D = $Nodes
@onready var match_line: Line2D = $MatchLine

var tiles:Dictionary={
	Types.NodeType.COFFEE:15,
	Types.NodeType.TEA:15,
	Types.NodeType.COCOA:15,
	Types.NodeType.MILK:5,
	Types.NodeType.SOY_MILK:5,
	Types.NodeType.ALMOND_MILK:5,
	Types.NodeType.WHITE_SUGAR:5,
	Types.NodeType.BROWN_SUGAR:5,
	Types.NodeType.LOVE:1,
	Types.NodeType.CONNECTOR:1		
}

var tile_bag:Array[PackedScene]
var cells:Array[Array]=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(back_tile_texture)
	nodes.polygon[0]=Vector2(0,0)
	nodes.polygon[1]=Vector2(cell_size*board_size.x,0)
	nodes.polygon[2]=Vector2(cell_size*board_size.x,cell_size*board_size.y)
	nodes.polygon[3]=Vector2(0,cell_size*board_size.y)
	_build_board()
	_fill_bag()
	_fill_board()
	Events.nodes_matched.connect(_on_nodes_matched)
	Events.start_crafting.connect(_on_start_crafting)
	
func _on_start_crafting():
	if not visible: 
		visible=true
	
func _fill_bag():
	for node_tile in tiles.keys():			
		for i in range(tiles[node_tile]):
			tile_bag.append(NodeScenes[node_tile])
		
func _fill_board():
	for x in board_size.x:
		for y in board_size.y:
			var tile :=get_new_tile()
			cells[x][y]=tile
			tile.visible=false
			tile.cell=Vector2i(x,y)
			nodes.add_child(tile)
			tile.position=map_to_world(Vector2i(x,y))
			tile.visible=true
			
				
func _build_board():
	while back.get_child_count():
		var tile = back.get_child(0)
		tile.queue_free()
		back.remove_child(tile)
		
	for x in board_size.x:
		var column=[]
		for y in board_size.y:
			column.append(null)
			var tile:=create_back_tile()
			back.add_child(tile)
			tile.position=map_to_world(Vector2i(x,y))	
		cells.append(column)	

func create_back_tile()->Sprite2D:
	var tile:=Sprite2D.new()
	tile.texture=back_tile_texture
	tile.scale=Vector2.ONE*back_tile_scale
	return tile
func cell_vector_size()->Vector2:
	return Vector2.ONE*cell_size
	
func world_to_map(world_coords:Vector2)->Vector2i:
	return (world_coords/cell_vector_size()) as Vector2i

func map_to_world(map_coords:Vector2i)->Vector2:
	return (map_coords as Vector2)*cell_vector_size()+cell_vector_size()/2.0

func _on_nodes_matched(matching_nodes:Array[NodeTile]):
	#TODO add ingredients
	#Logger.info("Board do match")
	var tmp_nodes:Array[NodeTile]=[] 
	
	#Prepare empty board to swap in
	var new_cells:Array[Array]=[]
	for x in board_size.x:			
		var column=[]
		for y in board_size.y:
			column.append(null)
		new_cells.append(column)
	
	#destroy matched nodes
	for node in matching_nodes:
		node.destroy()
		cells[node.cell.x][node.cell.y]=null
	#print_board()
	#push nodes in board down to fill gaps
	var extras:Array[int]=[]
	for x in board_size.x:			
		for y in board_size.y:			
			var node:NodeTile = cells[x][y]
			var holes:=0 if node!=null else 1
			for y2 in range(y+1, board_size.y):
				if cells[x][y2]==null:
					holes+=1
			if node!=null:			
				tmp_nodes.append(node)
				node.cell.y+=holes

			if y==0:
				extras.append(holes)
	#print("extras: %s" % [extras])	
	for x in extras.size():
		var col_count=extras[x]
		for y in range(col_count):
			var tile := get_new_tile()
			tile.visible=false
			tile.cell=Vector2i(x,y)
			nodes.add_child(tile)
			tile.position=map_to_world(Vector2i(x,0))+Vector2(0,(-col_count+y)*cell_size)
			tile.visible=true
			tmp_nodes.append(tile)
			#Logger.info("Added new tile for %s at %s" % [tile.cell, tile.position])
			
	#put in place new board
	for node in tmp_nodes:
		new_cells[node.cell.x][node.cell.y]=node
	cells=new_cells
	#print_board()
				
	_apply_gravity()


func get_new_tile()->NodeTile:
	if tile_bag.is_empty():
		_fill_bag()
	var tile_scene=tile_bag.pick_random() as PackedScene
	tile_bag.erase(tile_scene)
	var tile = tile_scene.instantiate() as NodeTile
	tile.board = self
	return tile
func _apply_gravity():
	pass

func print_board():
	print("board:")
	for y in range(board_size.y):
		var line=""
		for x in range(board_size.x):
			line+="%s" % (cells[x][y].type if cells[x][y] else "''")+"\t"
		print("|\t %s" % line)
	
func _input(event: InputEvent) -> void:
	if visible and Input.is_action_just_pressed("right_click"):
		visible=false
