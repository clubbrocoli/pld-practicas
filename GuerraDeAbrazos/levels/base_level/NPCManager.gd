extends Navigation2D

const NPC = preload("res://actors/npcs/npc.tscn")

export var npc_max_number: int = 5
export var rng_speed: int = 0
export var spawn_speedup: int = 0
export var speed_speedup: int = 0
export var skin_number = 4

var npc_number = 0
var skins_format_string = "res://assets/characters/Ejecutivo_%s_16x16.png"
var skins = []
onready var locations = $NPCSpawns.get_children() 
onready var npc_list = get_node("../YSort/NPCList")


func _ready():
	if npc_max_number == 0:
		set_process(false)
	else:
		for numb in range(0,skin_number):
			var skin_str = skins_format_string % numb
			skins.append(load(skin_str))
		

func _process(_delta):
	while(npc_list.get_child_count() < npc_max_number):
		#No iria aquí den ormal sino llamado desde fuera
		# Hacer los spawns independientes del mapa
		create_new_npc()


func create_new_npc():
	locations.shuffle()
	var spawn_location = locations[0].get_children()
	var end_location = locations[1].get_children()
	
	var spawn_position = spawn_location[randi() % spawn_location.size()].position
	var end_position = end_location[randi() % end_location.size()].position
	
	var npc_path = get_simple_path(spawn_position, end_position)
	
	var npc = NPC.instance()
	
	npc.start(npc_path, spawn_position, skins[randi() % skin_number])
	if rng_speed != 0:
		npc.speed += randi() % rng_speed
	npc_list.add_child(npc)


func _on_IncreaseSpawnRate_timeout():
	npc_max_number += spawn_speedup
	rng_speed += speed_speedup
