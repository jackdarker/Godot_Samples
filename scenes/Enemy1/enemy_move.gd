extends State

@export var animator : AnimationPlayer
@export var movespeed := int(350)
@export var dash_max := int(500)
var player : CharacterBody2D
var navigation_agent : NavigationAgent2D
var target : Node2D

func Enter():
	player = get_parent().get_parent()
	navigation_agent = player.get_node("NavAgent")
	target = player.target
	navigation_agent.set_target_position(target.global_position)
	#animator.play("walk")

func _physics_process(delta: float) -> void:
	if !navigation_agent:
		return
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		state_transition.emit(self, "enemy_idle")
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = player.global_position.direction_to(next_path_position) * movespeed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	player.velocity = safe_velocity
	player.move_and_slide()
