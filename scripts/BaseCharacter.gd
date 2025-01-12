class_name BaseCharacter extends CharacterBody2D

@export var sprite : Node2D
@export var healthbar : ProgressBar
@export var health : int
@export var flipped_horizontal : bool
@export var hit_particles : GPUParticles2D
var invincible : bool = false
var is_dead : bool = false

func _ready():
	init_character()
	
func _process(_delta):
	Turn()
	
#Add anything here that needs to be initialized on the character
func init_character():
	healthbar.visible=false
	healthbar.max_value = health
	healthbar.value = health

#Flip charater sprites based on their current velocity
func Turn():
	#This ternary lets us flip a sprite if its drawn the wrong way
	var direction = -1 if flipped_horizontal == true else 1
	if(velocity.x < 0):
		sprite.scale.x = -direction
	elif(velocity.x > 0):
		sprite.scale.x = direction

#region Taking Damage

#Play universal damage sound effect for any character taking damage and flashing red
func damage_effects():
	AudioManager.play_sound(AudioManager.BLOODY_HIT, 0, -3)
	after_damage_iframes()
	if(hit_particles):
		hit_particles.emitting = true

#After we are done flashing red, we can take damage again
func after_damage_iframes():
	invincible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.DARK_RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tween.finished
	invincible = false
	
func _take_damage(amount):
	if(invincible == true || is_dead == true):
		return
	healthbar.visible=true
	health -= amount
	healthbar.value = health;
	damage_effects()
	
	if(health <= 0):
		_die()
		
func _die():
	if(is_dead):
		return
		
	is_dead = true
	#Remove/destroy this character once it's able to do so unless its the player
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(self) and not is_in_group("Player"):
		queue_free()

#endregion

func unequip(slot:String)->void:
	var items=$Sprite.find_children(slot+"*")
	for i in items:
		i.visible=false
	if(slot=="Weapon"):
		$Sprite/hurtbox/middleshape.set_deferred("disabled",true) # causes cant change state while flushing queries otherwise
		$Sprite/hurtbox/farshape.set_deferred("disabled",true)

func equip(slot:String,equipname:String)->bool:
	var item=$Sprite.find_child(slot+"_"+equipname)
	if(item && !item.visible):
		unequip(slot)
		item.visible=true
		match equipname:
			"Sword1":
				$FSM/attacking.attacks[0]=$FSM/attacking/punch
				#$Sprite/hurtbox/middleshape.disabled=false
			"Spear1":
				$FSM/attacking.attacks[0]=$FSM/attacking/strike_long
				#$Sprite/hurtbox/farshape.disabled=false
		AudioManager.play_sound(AudioManager.ARMOR_PICK,0,1)
		return(true)
	else:
		return(false)

# when player presses activate_1 close to this node something might happen
# toogle switch, open chest,
# use zipline 
# start carrying this item
# taking this item (and equipping it)
func useMe()->void:
	pass
