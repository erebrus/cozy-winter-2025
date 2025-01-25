extends Node


signal interacted_with_item(item: Types.Item)
signal interacted_with_npc(npc: Types.NPC)


signal node_entered(node:NodeTile)
signal node_exited(node:NodeTile)
signal nodes_matched(nodes:Array[NodeTile])
