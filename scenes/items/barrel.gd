extends BaseCharacter

enum TYPE {BARREL=1, EXP_BARREL=2}

@export var Type:TYPE = TYPE.BARREL 

func _ready() -> void:
	$Sprite/Barrel1.visible=(Type==TYPE.BARREL || Type==TYPE.EXP_BARREL)
	if(Type==TYPE.EXP_BARREL): $Sprite/Barrel1.modulate=Color.INDIAN_RED
	$Hurtbox/CollisionShape2D2.disabled=true
	super()

func _die():
	if(!is_dead):
		if(Type==TYPE.EXP_BARREL):
			#show ticking-bomb and enable explosion collider
			var tween = $".".create_tween().set_loops(3)
			tween.tween_property(self, "modulate", Color.WHITE, 0.1)
			tween.tween_property(self, "modulate", Color.RED, 0.1)
			await tween.finished
			tween = $".".create_tween()
			tween.tween_property($Hurtbox/CollisionShape2D2,"disabled",false,0.3)
			tween.parallel().tween_property(self, "modulate:a", 0, 0.3)
			tween.chain().tween_property($Hurtbox/CollisionShape2D2,"disabled",true,0.1)
			await tween.finished	
	super() #calls _die() on base-class CharacterBase

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body!=self && (body.is_in_group("Enemys") || body.is_in_group("Player")):
		body._take_damage(10)
		AudioManager.play_sound(AudioManager.EXPLOSION, 0, 1)
