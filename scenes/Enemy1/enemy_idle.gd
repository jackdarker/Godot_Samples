extends State

@export var animator : AnimationPlayer

func Enter():
	animator.play("idle")
	pass

func Update(_delta):
	pass
