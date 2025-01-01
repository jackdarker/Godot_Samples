extends CharacterBody2D


const SPEED = 80.0
@export var home:Node2D
@export var target:Node2D
@onready var anim = get_node("AnimatedSprite2D")
@onready var initial_position = position
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D

var Mode:int = 0

func _physics_process(_delta):
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED
	move_and_slide()



func _on_timer_timeout() -> void:
	if nav_agent.is_navigation_finished():
		if Mode:
			Mode=0
			nav_agent.target_position = target.global_position #Vector2(331.4718, 206.2424)
		else:
			Mode=1
			nav_agent.target_position = home.global_position
