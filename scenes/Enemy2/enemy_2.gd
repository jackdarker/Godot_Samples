extends BaseCharacter

@export var min_speed:float = 100
@export var node:BaseCharacter
@export var animator:AnimationPlayer

func _ready()->void:
	super()
	#get_tree().create_timer(3.0).connect("timeout",$Sprite/Laser1.trigger)
	animator.play("walk")

func _physics_process(delta: float) -> void:
	node.velocity.x = min_speed*cos(global_rotation) #min_speed*-1 #move left
	node.velocity.x = min_speed*sin(global_rotation)
	node.move_and_slide()
	$Sprite/Laser1.trigger()
