extends State

@export var animator : AnimationPlayer
@export var movespeed := int(350)
@export var dash_max := int(500)
var player : CharacterBody2D
var navigation_agent : NavigationAgent2D
var target : Node2D
var navMapSteps :Array

func Enter():
	player = get_parent().get_parent()
	navigation_agent = player.get_node("NavAgent")
	target = player.target
	navMapSteps=[]
	_findMultiFloorPath()
	#navigation_agent.set_target_position(target.global_position)
	#animator.play("walk")

func _get_mob_floor()->int:
	return Global.nav2floor(navigation_agent.navigation_layers)

func _get_target_floor()->int:
	var _nav:NavigationRegion2D=target.get_parent().get_parent().get_node("Nav")	#Ly_Gnd->Terminals->Switch
	return Global.nav2floor(_nav.navigation_layers)

func _find_stairs()->Array:
	#TODO how to find stair candidates
	var stairs=target.get_parent().get_parent().get_parent().get_node("Stairs")	#
	return(stairs.get_children())


func _findMultiFloorPath():
	var mob_floor=_get_mob_floor()
	var target_floor=_get_target_floor()
	var map_rid=navigation_agent.get_navigation_map()	#there is only efault map
	# if start & target are on the same floor...
	if(mob_floor==target_floor):
		# ...and there is a route on this NavMap we only need to add it as single navMapStep
		navMapSteps=[{"target":target, "floor":target_floor}]
		# ...but if not?	TODO
	else:
	# else if start & target are on different BUT ADJOINING floors
		var stairs=_find_stairs()
		var stair=stairs[0]
	# ...look for a ladder; if there is a route from ladder to target and from start to ladder we will take it
		var step1:=NavigationServer2D.map_get_path(map_rid,player.global_position,stair.global_position,false,navigation_agent.navigation_layers)
		var step2:=NavigationServer2D.map_get_path(map_rid,stair.global_position,target.global_position,false,Global.floor2nav(target_floor))
	#	 add navMapStep for each path
		if(step1.size()>0 && step2.size()>0):
			navMapSteps=[{"target":stair, "floor":mob_floor},{"target":target, "floor":target_floor}]
	pass

func _physics_process(delta: float) -> void:
	if !navigation_agent:
		return
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		if(navMapSteps.size()<=0):
			state_transition.emit(self, "enemy_idle")
		else:
			var next=navMapSteps.pop_front()
			navigation_agent.navigation_layers=Global.floor2nav(next.floor)
			navigation_agent.set_target_position(next.target.global_position)
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = player.global_position.direction_to(next_path_position) * movespeed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	player.velocity = safe_velocity
	player.move_and_slide()
