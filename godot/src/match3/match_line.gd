extends Line2D

@export var min_match_length:=3
var nodes:Array[NodeTile]
var matching:=false
var tmpNode:NodeTile=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.node_entered.connect(_on_node_entered)
	Events.node_exited.connect(_on_node_exited)


func _on_start_match():
	pass
	
	
func _on_try_match():
	pass
	
func _on_node_entered(node:NodeTile):
	if not matching:
		tmpNode=node
		return
		
	if not node in nodes:
		if node_can_match(node):
			_add_node(node)
	elif nodes.size()>1:
		if node == nodes[nodes.size()-2]:
			_remove_last_node()
	
func _on_node_exited(node:NodeTile):
	if tmpNode:
		tmpNode=null
	
func _add_node(node:NodeTile):
	nodes.append(node)
	add_point(node.position)
	
func _remove_last_node():
	if not nodes.is_empty():
		nodes.remove_at(nodes.size()-1)
		remove_point(points.size()-1)
	
	

func are_nodes_adjacent(node1:NodeTile, node2:NodeTile):
	return abs(node1.cell.x-node2.cell.x) <=1 \
		and abs(node2.cell.x-node2.cell.x) <=1 \
		and node1.cell != node2.cell
		
func matched_nodes_of_group(group:Types.Group)->Array[NodeTile]:
	Logger.info("groups %d vs %s" % [group, nodes.map(func(x): return "%s-%s" % [x.type, x.group])])
	return nodes.filter(func (x): return x.group == group)
	
func node_can_match(node:NodeTile)->bool:
	if nodes.is_empty():
		Logger.info("empty- start match")
		return true
	var last:NodeTile = nodes[nodes.size()-1]
	if not are_nodes_adjacent(last, node):
		Logger.info("not adjacent - drop")
		return false
	if node.group!=Types.Group.MECHANIC:
		var of_group = matched_nodes_of_group(node.group)
		Logger.info("type %s group %s groups '%s'" %[node.type, node.group, of_group])
		if not of_group.is_empty() and of_group[0].type!=node.type:
			Logger.info("group fail - drop")
			return false
		return true
	else:
		return node.type == Types.NodeType.LOVE
	
func last_ingredient()->NodeTile:
	for i in range(nodes.size()-1,-1,-1):
		if nodes[i].type != Types.NodeType.CONNECTOR and\
			nodes[i].type != Types.NodeType.LOVE:
				return 	nodes[i]
	return null

func _unhandled_input(event: InputEvent) -> void:
	#if nodes.is_empty():
		#return	
	if event is InputEventMouseButton:
		var mev := event as InputEventMouseButton
		if mev.button_index==MOUSE_BUTTON_LEFT:
			if mev.pressed:
				matching=true
				if tmpNode:
					_add_node(tmpNode)
			else:
				matching=false
				if nodes.size()>=min_match_length:
					Events.nodes_matched.emit(nodes)
					#TODO sfx?
				else:
					#TODO match insuficient, sfx?
					pass
				clear_points()
				nodes.clear()
				
			
			
