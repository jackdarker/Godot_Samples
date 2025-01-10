class_name Player
extends BaseCharacter

# Keep this in sync with the AnimationTree's state names.
const States = {
	IDLE = "idle",
	WALK = "walk",
	RUN = "run",
	FLY = "fly",
	FALL = "fall"
	}

@onready var anim = $AnimationTree
@onready var initial_position = position
#@onready var sprite:Node2D = $Sprite
@onready var sprite_scale:float= sprite.scale.x
var interactable:Node2D

const SPEED = 60.0
var lives = 1 # lives counter

func _ready() -> void:
	#$AnimationTree.active = true
	super()
	$UseIndicatore.visible=false
	Global.interact_touched.connect(Callable(self , "interact_touched"))
	unequip("Head")
	unequip("Weapon")
	pass
	
func old_physics_process(_delta: float) -> void:
	#
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	velocity.x=0
	velocity.y=0
	if direction_x:
		velocity.x = direction_x * SPEED
		velocity.y = 0
		if not is_zero_approx(velocity.x):
			if velocity.x > 0.0:
				sprite.scale.x = 1.0 * sprite_scale
			else:
				sprite.scale.x = -1.0 * sprite_scale

	elif direction_y:
		velocity.x = 0
		velocity.y = direction_y * SPEED
	move_and_slide()
	
	if abs(velocity.x) > 50 || abs(velocity.y) > 50:
		$AnimationTree["parameters/state/transition_request"] = States.RUN
		#$AnimationTree["parameters/run_timescale/scale"] = abs(velocity.x) / 60
	elif velocity.x || velocity.y:
		$AnimationTree["parameters/state/transition_request"] = States.WALK
		$AnimationTree["parameters/walk_timescale/scale"] = abs(velocity.x) / 12
	else:
		$AnimationTree["parameters/state/transition_request"] = States.IDLE
	
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("hit3")
	if area.is_in_group("Items"):
		area.pickup(self)
	
func revive() -> void:
	position = initial_position
	# Lives counter
	lives = lives - 1

func interact_touched(body:Node2D,touched:bool, Message:String)->void:
	$UseIndicatore.text=Message
	$UseIndicatore.visible=touched
	$FSM/interact.setInteractable(body if touched else null)
	pass

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict
