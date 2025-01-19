@tool
extends AudioStreamPlayer2D
class_name WAUAudioPlayer

@export var sound_collection: SoundsCollection:
	set(value):
		sounds = {}
		sound_collection = value
		create_sounds()

@export var track_name: String = "":
	set(value):
		track_name = value
		if value in sounds:
			stream = sounds[track_name]



var sounds: Dictionary = {} 

# var sounds = {STEP = AudioStreamRandomizer.new(),
# STOP_MOVING = preload("res://asset/sfx/player/footsteps/footstep5.wav"),
# DEAL_DMG = preload("res://asset/sfx/player/dealing_damage/8-bit_damage.wav")}

var active_sound = null

func _ready():
	self.finished.connect(_on_sound_finished)
	# for i in range(4):
	# 	sounds["STEP"].add_stream(i,load("res://asset/sfx/player/footsteps/footstep" + str(i+1) + ".wav"), 0.25)

func _on_sound_finished():
	self.active_sound = null
	
func create_sounds():
	for track in sound_collection.sounds:
		sounds[track.track_name] = track.track_file

func play_sound(sound_name, from_position=0.):
	if sounds.size() > 0:
		if sound_name in sounds.keys():
			if active_sound != sounds[sound_name]:
				stream = sounds[sound_name]
				active_sound = sounds[sound_name]
			else:
				return

			play(from_position)
