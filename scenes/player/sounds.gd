extends AudioStreamPlayer2D
class_name WAUAudioPlayer

#@export var Sounds: Dictionary = {}

var Sounds = {STEP = AudioStreamRandomizer.new(),
STOP_MOVING = preload("res://asset/sfx/player/footsteps/footstep5.wav"),
DEAL_DMG = preload("res://asset/sfx/player/dealing_damage/8-bit_damage.wav")}

var active_sound = null

func _ready():
	self.finished.connect(_on_sound_finished)
	for i in range(4):
		Sounds["STEP"].add_stream(i,load("res://asset/sfx/player/footsteps/footstep" + str(i+1) + ".wav"), 0.25)
func _on_sound_finished():
	self.active_sound = null
	

func play_sound(sound_name, position=null):
	if sound_name in Sounds.keys():
		if active_sound != Sounds[sound_name]:
			stream = Sounds[sound_name]
			active_sound = Sounds[sound_name]
		else:
			return

		play()
