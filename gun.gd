extends Node

#a gun fires a projectile
#TODO: resuse projectile instances
@export var ROF:float = 0.5	#rate of fire in shots per second
@export var Projectile:PackedScene
@export var SpawnPoint:Node2D
@export var SpawnGroup:String = "Enemys"
@onready var parent:Node = get_node("/root/Level/dynamicInstances")

var _readyTime:float

func _ready() -> void:
	_readyTime=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _readyTime>0:
		_readyTime-=delta
	pass

func trigger()->void:
	if _readyTime<=0:
		_readyTime=ROF
		var shot=Projectile.instantiate()
		shot.add_to_group(SpawnGroup)
		shot.add_to_group("dynamic")		
		shot.global_transform=SpawnPoint.global_transform
		shot.global_rotation=SpawnPoint.global_rotation
		parent.add_child(shot)
