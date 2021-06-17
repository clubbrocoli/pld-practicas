extends "res://levels/base_level/base_level.gd"

export var npc_pop_factor = 7

func _ready():
	#Sobreescribo aquí los valores del NPC manager para el nivel en cuestión
	#En este nivel nos interesa más que sea estable la cantidad de npcs q salen
	$NPCManager.npc_max_number = $YSort/Players.get_child_count()*npc_pop_factor
	$NPCManager.rng_speed = 40
