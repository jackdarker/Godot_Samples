extends Node2D

var current_floor:int=-1

func setBonus(bonus)->void:
	$TimerBonus.stop()
	if(bonus>=1):
		Global.Bonus+=bonus
		$TimerBonus.start(4) #timeout will reset bonus but adding another bonus resets timer 
	else:
		Global.Bonus=1

func change_floor(_new_floor:int):
	var new_floor=0	#Todo actual just toggling floors
	#Todo fadeout-in on change
	#Todo also toggle NPC visibility
	if(current_floor==0):
		new_floor=1
	var buildings = get_node(Global.build_node).get_children()
	for building in buildings:
		building.change_floor(new_floor)
	current_floor = new_floor
	# example: floors use physics layer bits; player has method to set mask
	var bit = 1 << new_floor		#TODO cleanup collsionionmask
	$Player.set_collision_mask(bit)
	# reposition player to ladder destination if needed
	# camera or transition handling here
		
func _ready() -> void:
	get_tree().paused = false  #TODO handled by ready_counter
	Global.score=0
	Global.Bonus=1
	#Global.pills=$Items.get_child_count()-100
	#$TimerBonus.timeout.connect(func(): self.setBonus(-1))
	#Global.bonus_changed.connect(Callable(self , "setBonus"))#.bind(1))
	#Global.score_changed.connect(Callable(self , "checkVictory"))
	Global.player_death.connect(Callable(self , "player_revive"))
	var level_data=preload("res://scenes/level_3.tscn").instantiate()
	for i in $level_data.get_children():
		$level_data.remove_child(i)
		i.queue_free()
	#$level_data.add_child(level_data)
	remove_child($level_data)
	add_child(level_data)
	Global.applyMapChanges()
	$Player.spawner=$level_data.get_node_or_null("Spawn_Player")
	player_revive()
	change_floor(0)

func _input(event):
	if event.is_action_released("pause"):
		if not get_tree().paused:
			get_node("/root/Level/pause_screen").visible = true
			get_tree().paused = true

func player_revive()->void:
	$Player.revive()
	if $Player.lives <= 0:
		#get_node("/root/Pack-man/Lives/SprLifecounter0").visible = false
		get_tree().paused = true
		get_node("/root/Level/game_over_screen").visible = true

func checkVictory(_change)->void:
	return #TODO
	if(Global.pills<1):
		get_tree().paused=true
		Global.goto_scene("res://scenes/finished_menu.tscn")

func _on_TP1_body_entered(body):
	body.position.x = 584
	
func _on_TP2_body_entered(body):
	body.position.x = 168

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict


func _on_game_over_screen_visibility_changed() -> void:
	#at end of game check if we have highscore amd save if so
	if !$game_over_screen.visible: return
	Global.updateHighscore()
