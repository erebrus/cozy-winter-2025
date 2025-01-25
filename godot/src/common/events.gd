extends Node


signal interacted_with_item(item: Types.Item)
signal interacted_with_npc(npc: Types.NPC)

signal drink_requested(request: DrinkRequest)
signal drink_completed(drink: Drink)

signal node_entered(node:NodeTile)
signal node_exited(node:NodeTile)
signal nodes_matched(nodes:Array[NodeTile])
