extends State

@export var animator : AnimationPlayer
var body:Node2D=null
# Called when the node enters the scene tree for the first time.

func Enter():
	interactWith()
	#animator.play("idle")
	pass

func Update(delta : float):
	state_transition.emit(self, "idle")

func setInteractable(interactable:Node2D)->void:
	body=interactable
	pass

func interactWith()->void:
	body.useMe()
	pass
