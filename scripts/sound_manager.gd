extends Node

const MAX_SOUNDS = 35

var volume:float = .5 #.5
var musicVolume: float = .5 #.5
var max_distance = 200.0

var active_sounds = [] #keeps track of all sounds being played
@onready var player

#path -> sound_file
#pos -> position of sound (optional)
#overide -> range of (0-1) subtracts overide from sound (optional)

func play_sound(path: String, pos:Vector2 = Vector2.ZERO, overide: float = 0) -> void:
	
	if active_sounds.size() >= MAX_SOUNDS:
		return
	
	var stream = load(path)
	
	if not stream:
		return
	
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = stream
	
	var distance_volume_scale = 1.0  # Default full volume

	#Only apply distance scaling if a non-zero position was given
	if pos != Vector2.ZERO:
		var distance = pos.distance_to(player.position)
		
		distance_volume_scale = clamp(1.0 - (distance / max_distance), 0.0, 1.0)
		if distance_volume_scale <= 0.0:
			audio_player.queue_free()
			return
		if distance >= max_distance:
			return
	#scales volume based on how many sounds are being played and by distance 
	var volume_scale = (((1.0 - (active_sounds.size() * 0.02)) * distance_volume_scale))
	audio_player.volume_db = linear_to_db(clamp((volume_scale * volume) - overide, 0.01, 1.0))
	if volume == 0:
		audio_player.volume_db = -999
	
	var pitch_scale = 1.0 - (randf_range(-0.7,0.3)) #random pitch
	audio_player.pitch_scale = pitch_scale
	audio_player.play()
	active_sounds.append(audio_player)
	
	audio_player.connect("finished", Callable(self, "_on_sound_finished").bind(audio_player))

func play_ui_sound(path: String, overide: float = 0): #for UI sounds (no pitch scaling / distance)
	
	var stream = load(path)
	
	if not stream:
		return
	
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = stream

	audio_player.volume_db = linear_to_db(clamp((volume) - overide, 0.01, 1.0))
	if volume == 0:
		audio_player.volume_db = -999
	audio_player.play()
	active_sounds.append(audio_player)

	audio_player.connect("finished", Callable(self, "_on_sound_finished").bind(audio_player))

func play_music(path: String = "res://sounds/music.mp3", overide: float = 0):
	var stream = load(path)
	
	if not stream:
		return
	
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = stream

	audio_player.bus = "Music"

	audio_player.volume_db = linear_to_db(clamp((volume) - overide, 0.01, 1.0))
	if volume == 0:
		audio_player.volume_db = -999
	audio_player.play()
	active_sounds.append(audio_player)

	audio_player.connect("finished", Callable(self, "_on_sound_finished").bind(audio_player))


func _on_sound_finished(player: AudioStreamPlayer):
	
	active_sounds.erase(player)
	player.queue_free()
