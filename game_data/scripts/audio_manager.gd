class_name CustomAudioManager
extends Node

const AUDIO_EXTENSIONS = ["ogg", "mp3", "wav"]

var audioRepo: Node2D
var musicPlayer: AudioStreamPlayer2D
var effectPlayers: Array[AudioStreamPlayer2D]
var audio_cache: Dictionary[String, AudioStream]

# AUDIO PACKAGES GO HERE #
const AUDIO_PACKAGES: Dictionary[String, Array] = {
	'slash': ['slash1', 'slash2']
}


func setup(audioSources: Node2D):
	audioRepo = audioSources
	load_audio_cache()
	
func play_audio(audio_name: String, volume_db: float = 0.0, pitch: float = 1.0, bus: String = "Master") -> AudioStreamPlayer2D:
	var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio.stream = audio_cache[audio_name]
	audio.bus = bus
	audio.volume_db = volume_db
	audio.pitch_scale = pitch
	audioRepo.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()
	effectPlayers.push_back(audio)
	return audio
	
func play_package_audio(package_name: String) -> AudioStreamPlayer2D:
	return play_audio(AUDIO_PACKAGES[package_name].pick_random())
	
func play_layered(first_sound: String, second_sound:String, delay: float) -> void:
	play_audio(first_sound)
	await get_tree().create_timer(delay)
	play_audio(second_sound)
	
## Ignores the music folder to avoid expensive caches, loading just the smaller effects. Loading music can be handled seperately.
func load_audio_cache() -> void:
	# Load all the non music folders here!
	audio_cache.merge(load_audio_from_directory("res://game_data/audio_files/effects/")) 

func load_audio_from_directory(dir_path: String) -> Dictionary:
	var sounds := {}
	var seen_paths := {}  # avoids loading x.ogg twice in the editor (x.ogg + x.ogg.import)

	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("Could not open folder ", dir_path)
		return sounds

	dir.list_dir_begin()
	var item := dir.get_next()
	while item != "":
		var item_path := dir_path.path_join(item)

		if dir.current_is_dir():
			var sub := load_audio_from_directory(item_path)
			for key in sub:
				if sounds.has(key):
					push_warning("Duplicate audio name '%s', overwriting" % key)
				sounds[key] = sub[key]
		else:
			# Exported builds list "x.ogg.import" / "x.ogg.remap" instead of "x.ogg"
			var clean_path := item_path.trim_suffix(".import").trim_suffix(".remap")

			if clean_path.get_extension().to_lower() in AUDIO_EXTENSIONS \
					and not seen_paths.has(clean_path):
				seen_paths[clean_path] = true
				var stream = load(clean_path)
				if stream is AudioStream:
					var key := clean_path.get_file().get_basename()
					if sounds.has(key):
						push_warning("Duplicate audio name '%s', overwriting" % key)
					sounds[key] = stream

		item = dir.get_next()
	dir.list_dir_end()
	return sounds
