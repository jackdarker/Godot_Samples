class_name Building extends Node2D

@export var data:DataBuilding


func _possible_doors(floor:int=0)->Array:
	if (floor==0):
		return($Ly_Gnd/Doors.get_children())
	else:
		return($Ly_Crawl/Doors.get_children())

# !! TODO Ly_Crawl actually uses Tileset-Copy with adjusted Collisionflag

func change_floor(new_floor:int):
	var Ly_Gnd:TileMapLayer= get_node_or_null("Ly_Gnd")
	var Ly_Crawl:TileMapLayer= get_node_or_null("Ly_Crawl")
	if(Ly_Gnd):
		Ly_Gnd.visible=(new_floor==0)
	if(Ly_Crawl):
		Ly_Crawl.visible=(new_floor==1)
	#var Doors= get_node_or_null("Doors")		#TODO Terminals & Door up and down
	#Doors.visible=(new_floor==0)
	#var Terminals= get_node_or_null("Terminals")
	#Terminals.visible=(new_floor==0)
	
#override for data to save
func editor_serialize()->Dictionary:
	return({})

#override for data to load
func editor_deserialize(_data:Dictionary):
	pass
