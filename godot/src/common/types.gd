extends Node


enum GameMusic {EASY, NORMAL, HARD}

enum NodeType {	
	COFFEE,
	TEA,
	COCOA,
	MILK,
	SOY_MILK,
	ALMOND_MILK,
	WHITE_SUGAR,
	BROWN_SUGAR,
	HONEY,
	LOVE,
	CONNECTOR
}

enum NPC {
	NPC_A,
	NPC_B,
	NPC_C
}

enum Item {
	FIREPLACE
}

enum Group {BEVERAGE, MILK, SWEET, MECHANIC}

func npc_key(value: NPC) -> String:
	return NPC.keys()[value]
	

func item_key(value: Item) -> String:
	return Item.keys()[value]
