extends Node2D

const NPC = preload("res://actors/npcs/npc.tscn")

export var npc_max_number = 5
var npc_number = 0
onready var locations = $NPCSpawns.get_children() 
onready var npc_list = get_node("../YSort/NPCList")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(_delta):
	while(npc_list.get_child_count() < npc_max_number):
		#No iria aquí den ormal sino llamado desde fuera
		# Hacer los spawns independientes del mapa
		create_new_npc()
		
		
func create_new_npc():
	var spawn_location_index = randi() % locations.size()
	var spawn_location = locations[spawn_location_index].get_children()
	var spawn_position = spawn_location[randi() % spawn_location.size()].position
	
	# Esto seguro que hay una manera meno perra de hacerlo
	var end_location_index = randi() % locations.size()
	while (end_location_index == spawn_location_index):
		end_location_index = randi() % locations.size()
		
	var end_location = locations[end_location_index].get_children()
	var end_position = end_location[randi() % end_location.size()].position
	
	var npc_path = $Navigation2D.get_simple_path(spawn_position,end_position)
	
	var npc = NPC.instance()
	npc.start(npc_path,spawn_position)
	npc_list.add_child(npc)
	
	
	
	
	
	

	
