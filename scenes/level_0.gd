extends Node2D


func setBonus(bonus)->void:
	$TimerBonus.stop()
	Global.Bonus=bonus
	if(bonus>1):
		$TimerBonus.start(4)
		
func _ready() -> void:
	#get_tree().paused = false  handled by ready_counter
	current_scene = root.get_child(-1)
	$TimerBonus= Timer.new()
	$TimerBonus.timeout.connect(Callable(self , "setBonus").bind(1))
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			get_node("/root/Level/pause_screen").visible = true
			get_tree().paused = true
			
	if event.is_action_pressed("action_1"):
		$Ly_Gnd/GhostDoor.process_mode=Node.PROCESS_MODE_DISABLED #this disables the physics but not the sprite
		

func _on_TP1_body_entered(body):
	body.position.x = 584
	
func _on_TP2_body_entered(body):
	body.position.x = 168
