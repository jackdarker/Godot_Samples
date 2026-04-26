class_name Building extends Node2D

@export var data:DataBuilding

func _enter_tree() -> void:
	#var Nav2=$Ly_Crawl/Nav.duplicate()
	#$Ly_Crawl/Nav.enabled=false
	#$Ly_Crawl.add_child(Nav2)
	#NavigationServer2D.free_rid(get_world_2d().navigation_map)	
	

	#var region = NavigationServer2D.region_create()
	#NavigationServer2D.region_set_navigation_layers(region,2)
	#NavigationServer2D.region_set_map(region, Global.map_crawl)
	#var navigation_poly = NavigationMesh.new()
	#navigation_poly= $Ly_Crawl/Nav.navigation_polygon
	#NavigationServer2D.region_set_transform(region, $Ly_Crawl/Nav.global_transform)
	#NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)
	
	#region = NavigationServer2D.region_create()
	#NavigationServer2D.region_set_map(region, Global.map_gnd)
	#navigation_poly = NavigationMesh.new()
	#navigation_poly = $Ly_Gnd/Nav.navigation_polygon
	#NavigationServer2D.region_set_transform(region, $Ly_Gnd/Nav.global_transform)
	#NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)
	#Global.map_gnd=get_world_2d().navigation_map
	pass

func _ready() -> void:
	var nav:NavigationRegion2D=$Ly_Crawl/Nav
	NavigationServer2D.region_set_map(nav.get_rid(),Global.map_crawl)
	nav.bake_navigation_polygon()
	nav=$Ly_Gnd/Nav
	NavigationServer2D.region_set_map(nav.get_rid(),Global.map_gnd)
	nav.bake_navigation_polygon()

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
