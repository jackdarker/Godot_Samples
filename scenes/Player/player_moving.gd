extends State

@export var movespeed := float(350)
@export var dash_max := float(500)
@export var min_speed:float = 100
var dashspeed := float(100)
var can_dash := bool(false)
var dash_direction := Vector2(0,0)

var player : CharacterBody2D
@export var animator : AnimationPlayer

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	animator.play("walk")

func Update(delta : float):
	if player.is_dead:
		Transition("dieing")
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	Move(input_dir)
	LessenDash(delta)

	if(Input.is_action_just_pressed("action_2") && can_dash):
		start_dash(input_dir)
		
	#if Input.is_action_just_pressed("attack_1") or Input.is_action_just_pressed("attack_2"):
	#	Transition("attacking")
	
func Move(input_dir : Vector2):
	#Suddenly turning mid dash
	if(dash_direction != Vector2.ZERO and dash_direction != input_dir):
		dash_direction = Vector2.ZERO
		dashspeed = 0
	var _min_speed = min_speed if input_dir.x>=0 else min_speed* 0.5  #slowdown when pressing left
	#move at least with min_speed
	player.velocity.x = maxf(_min_speed,minf(movespeed,(input_dir.x * movespeed)) + dash_direction.x * dashspeed)
	player.velocity.y = input_dir.y * movespeed + dash_direction.y * dashspeed 
	player.move_and_slide()

	if(input_dir.length() <= 0):
		#Transition("idle")   stay in moving to maintain min_speed
		pass

func start_dash(input_dir : Vector2):
	#AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.3, -1)
	dash_direction = input_dir.normalized()
	dashspeed = dash_max
	#animator.play("Dash")
	can_dash = false

func LessenDash(delta : float):
	#Higher multiplier values makes the dash shorter
	var multiplier : float = 4.0
	var timemultiplier : float = 4.1
	
	#slow down the dash over time, both as a fraction of dashspeed and also time
	#While clamping it between 0 and dash_max
	dashspeed -= (dashspeed * multiplier * delta) + (delta * timemultiplier)
	dashspeed = clamp(dashspeed, 0, dash_max)
	
	if(dashspeed <= 0):
		can_dash = true
		dash_direction = Vector2.ZERO
		
	if(animator.current_animation == "Dash"):
		await animator.animation_finished
		animator.play("walk")

#We cannot allow a transition before the dash is complete and the animation has stopped playing
func Transition(newstate : String):
	if(dashspeed <= 0):
		state_transition.emit(self, newstate)
