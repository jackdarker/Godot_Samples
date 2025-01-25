extends Area2D

const SPEED:float=300
const LIFETIME:float=3	#
var lifetime:float
var direction:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime=LIFETIME
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x+=delta*SPEED*cos(global_rotation)
	position.y+=delta*SPEED*sin(global_rotation)
	lifetime-=delta
	if(lifetime<=0):
		queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemys") && self.is_in_group("Player") \
	|| body.is_in_group("Player") && self.is_in_group("Enemys"):
		deal_damage(body)
		AudioManager.play_sound(AudioManager.PLAYER_ATTACK_HIT, 0, 1)

func deal_damage(enemy):# : EnemyMain):
	#hit_particles.emitting = true
	enemy._take_damage(5)
