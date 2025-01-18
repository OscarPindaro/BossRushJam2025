extends AudioStreamPlayer2D
class_name WAUAudioPlayer

#@export var Sounds: Dictionary = {}

const Sounds = {STEP = preload("res://scene_prova/asset_a_caso/step2.wav"),
STOP_MOVING = preload("res://scene_prova/asset_a_caso/cosmonaut1.wav")}

var active_sound = null

func _ready():
	self.finished.connect(_on_sound_finished)

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
