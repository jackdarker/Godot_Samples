extends Node

#This class preloads all of our sound effects so that they can be played at a momets notice
#region Preloaded Sounds
const PLAYER_ATTACK_HIT = preload("res://assets/audio/kenney_rpg-audio/Audio/footstep04.ogg")
const PLAYER_ATTACK_SWING = preload("res://assets/audio/kenney_rpg-audio/Audio/footstep03.ogg")
#const ENEMY_HIT = preload("res://Art/Audio/Effects/Enemy_hit.ogg")
const BLOODY_HIT = preload("res://assets/audio/kenney_impact-sounds/Audio/impactPunch_heavy_003.ogg")
const COIN_PICK = preload("res://assets/audio/Select 1.wav")
const ARMOR_PICK = preload("res://assets/audio/kenney_rpg-audio/Audio/clothBelt2.ogg")
const NO_PICK = preload("res://assets/audio/kenney_impact-sounds/Audio/footstep_concrete_002.ogg")
#const QUEST_SOUND = preload("res://Art/Audio/Effects/QuestSound.ogg")
#endregion

var audio_players = []
var max_players = 8
var starting_players = 3

func _ready() -> void:
	initiate_audio_stream()
	
#Play a sound, call this function from anywhere
#offset lets you start the sound with an offset, like starting the sound at 0.1s into the clip
#Arguments(audio_clip, offset, volume)
#Example when calling this function:
#AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.25, 1)
func play_sound(audiostream : AudioStream , offset : float, volume : float):
	#Loop through and find an available player currently not playing a sound
	var available_player = audio_players[0]
	for player in audio_players:
		if not player.is_playing():
			available_player = player
			break

	# If no player is available and we havent reached the maximum amount of players, create a new one
	if available_player == null and audio_players.size() < max_players:
		available_player = AudioStreamPlayer.new()
		audio_players.append(available_player)
		add_child(available_player)

	available_player.stream = audiostream
	available_player.pitch_scale = randf_range(0.9, 1.1)
	available_player.volume_db = volume
	available_player.play(offset)

#Instantiate audiostreams into the scene
func initiate_audio_stream():
	for i in range(starting_players):
		var player = AudioStreamPlayer.new()
		audio_players.append(player)
		add_child(player)
