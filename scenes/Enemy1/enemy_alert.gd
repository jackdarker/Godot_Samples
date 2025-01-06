extends State

@export var animator : AnimationPlayer

func Enter():
	animator.play("alert")
	pass

func Update(_delta):
	pass
