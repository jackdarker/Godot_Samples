extends State

@export var animator : AnimationPlayer

func Enter():
	animator.play("idle")
	pass
	
func Update(_delta : float):
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()):
		state_transition.emit(self, "moving")
		
	if Input.is_action_just_pressed("attack_1")  or Input.is_action_just_pressed("attack_2"):
		state_transition.emit(self, "attacking")
	
	if Input.is_action_just_pressed("action_1"):
		state_transition.emit(self, "interact")
