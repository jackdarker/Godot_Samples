extends CharacterBody2D

enum TYPE{RED,BLUE,ORANGE,PINK}

@export var maxSpeed:float = 80.0
var speed:float
@export var home:Node2D
@export var target:Node2D
@export var Type:TYPE=TYPE.RED
@onready var anim = get_node("AnimatedSprite2D")
@onready var initial_position = position
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D

var Mode:Global.MODE = Global.MODE.SLEEP

func reset()->void:
	Mode=Global.MODE.SLEEP
	speed=maxSpeed
	#collide with walls
	set_collision_mask_value(1, true)
	set_collision_layer_value(1,true)
	#set_collision_layer_value(1, false)
	#set_collision_layer_value(3,true)
	match Type:
		TYPE.RED:
			anim.play("red")
			$Timer.wait_time=1.0
		TYPE.BLUE:
			anim.play("blue")
			$Timer.wait_time=1.5
		TYPE.ORANGE:
			anim.play("orange")
		TYPE.PINK:
			anim.play("pink")

func _physics_process(_delta):
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * speed
	move_and_slide()

func _ready() -> void:
	Global.connect("scare", Callable(self , "_on_scare"))
	reset()	
	
# from wikipedia:
# Blinky (red), Pinky (pink), Inky (cyan), and Clyde (orange)
# Blinky gives direct chase to Pac-Man; Pinky and Inky try to position themselves in front of Pac-Man, usually by cornering him; and Clyde switches between chasing Pac-Man and fleeing from him
func _on_timer_timeout() -> void:
	if Mode==Global.MODE.RUN:
		nav_agent.target_position = home.global_position
		if nav_agent.is_navigation_finished():
			reset()

	elif Mode == Global.MODE.CHASE:
		if(Type==TYPE.PINK):
			pass
		else:	
			nav_agent.target_position = target.global_position #Vector2(331.4718, 206.2424)
		
	elif Mode == Global.MODE.FRIGHTENED:
		#$Timer.stop() 
		#reset()
		#Mode=Global.MODE.CHASE
		#$Timer.start()
		pass
	
	elif Mode==Global.MODE.SLEEP:
		match Type:
			TYPE.RED:
				Mode=Global.MODE.CHASE
			TYPE.BLUE:
				if(Global.score>100):
					Mode=Global.MODE.CHASE
			_:
				pass
				
func _on_scare(on)-> void:
	if(on):
		speed=maxSpeed/2
		anim.play("frightened")
		Mode=Global.MODE.FRIGHTENED
		nav_agent.target_position = home.global_position #Vector2(376,224) #TODO flee before player
		#$Timer.stop() 
		#$Timer.start(8)
	else:
		reset()

func kill()->void:
	anim.play("run")
	Mode=Global.MODE.RUN
	#ignore walls to get through ghostdoor, navigation will still follow corridors
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	Global.scoreChange(100*Global.Bonus,0)
	Global.bonus_changed.emit(1)
	$Timer.stop() 
	$Timer.start(1)

func revive()->void:
	reset()
	self.position=initial_position
