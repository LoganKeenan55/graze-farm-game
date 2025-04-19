extends Node

const MAX_SOUNDS = 10

var active_sounds = [] #keeps track of all sounds being played

func play_sound(path: String) -> void:
	if active_sounds.size() >= MAX_SOUNDS:
		return
	
	var stream = load(path)
	
	if not stream:
		return
	
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = stream
	
	#scales volume based on how many sounds are being played
	var volume_scale = 1.0 - (active_sounds.size()* 0.2)
	audio_player.volume_db = linear_to_db(clamp(volume_scale, 0.2, 1.0)) 
	
	var pitch_scale = 1.0 - (randf_range(-1.0,0.2))
	audio_player.pitch_scale = pitch_scale
	audio_player.play()
	active_sounds.append(audio_player)
	
	audio_player.connect("finished", Callable(self, "_on_sound_finished").bind(audio_player))

func _on_sound_finished(player: AudioStreamPlayer):
	active_sounds.erase(player)
	player.queue_free()
