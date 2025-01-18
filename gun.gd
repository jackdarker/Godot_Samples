extends Node

#a gun fires a projectile
#TODO: resuse projectile instances
@export var ROF:float = 0.5	#rate of fire in shots per second
@export var Projectile:PackedScene
@export var SpawnPoint:Node2D
@export var SpawnGroup:String = "Enemys"
var _readyTime:float

func _ready() -> void:
	_readyTime=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _readyTime<=0 && Input.is_action_pressed("attack_1"): # .is_action_just_pressed("attack_1"):
		_readyTime=ROF
		var shot=Projectile.instantiate()
		shot.add_to_group(SpawnGroup)
		shot.global_transform=SpawnPoint.global_transform
		get_tree().root.add_child(shot)
	else:
		_readyTime-=delta
	pass
