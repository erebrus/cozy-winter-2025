extends Node

enum GameMusic {EASY, NORMAL, HARD}


enum NPC {
	NPC_A,
	NPC_B,
	NPC_C
}

enum Item {
	FIREPLACE
}

func npc_key(value: NPC) -> String:
	return NPC.keys()[value]
	

func item_key(value: Item) -> String:
	return Item.keys()[value]
