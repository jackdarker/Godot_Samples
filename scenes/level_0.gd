extends Node2D


func setBonus(bonus)->void:
	$TimerBonus.stop()
	if(bonus>=1):
		Global.Bonus+=bonus
		$TimerBonus.start(4) #timeout will reset bonus but adding another bonus resets timer 
	else:
		Global.Bonus=1
		
func _ready() -> void:
	#get_tree().paused = false  handled by ready_counter
	Global.score=0
	Global.Bonus=1
	Global.pills=$Items.get_child_count()-100
	$TimerBonus.timeout.connect(func(): self.setBonus(-1))
	Global.bonus_changed.connect(Callable(self , "setBonus"))#.bind(1))
	Global.score_changed.connect(Callable(self , "checkVictory"))
	Global.player_death.connect(Callable(self , "player_revive"))
	pass

func _input(event):
	if event.is_action_released("pause"):
		if not get_tree().paused:
			get_node("/root/Level/pause_screen").visible = true
			get_tree().paused = true
			
	if event.is_action_pressed("action_1"):
		$Ly_Gnd/GhostDoor.process_mode=Node.PROCESS_MODE_DISABLED #this disables the physics but not the sprite
		

func player_revive()->void:
	$Foes/GhostRed.revive()
	$Foes/GhostRed2.revive()
	$Foes/GhostBlue.revive()
	$Player.revive()
	if $Player.lives <= 0:
		#get_node("/root/Pack-man/Lives/SprLifecounter0").visible = false
		get_tree().paused = true
		get_node("/root/Level/game_over_screen").visible = true

func checkVictory(_change)->void:
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
