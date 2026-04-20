extends State

@export var animator : AnimationPlayer

func Enter():
	animator.play("idle")
	pass

func Update(_delta):
	if(get_parent().get_parent().target):
		state_transition.emit(self, "enemy_move")
	pass
