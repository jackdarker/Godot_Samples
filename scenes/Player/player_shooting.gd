extends State

@export var animator : AnimationPlayer

func Enter():
	AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.3, 1)
	animator.play("laser")
	await animator.animation_finished
	state_transition.emit(self, "idle")
