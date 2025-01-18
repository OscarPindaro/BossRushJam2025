extends HBoxContainer
class_name AudioSlider

@export var bus_name : String
@export var label_text :String
var bus_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if label_text != null and !label_text.is_empty():
		$LabelContainer/Label.text = label_text
	else:
		$LabelContainer/Label.text = name
	bus_index = AudioServer.get_bus_index(bus_name)
	print (bus_index)
	print
	$SliderContainer/Volume.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	var volume_db = linear_to_db($SliderContainer/Volume.value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	

func linear_to_db(value: float) -> float:
	return 20 * (log(value/$SliderContainer/Volume.max_value)/log(10) ) if value > 0 else -80

func db_to_linear(value: float):
	return pow(10, value/20) * $SliderContainer/Volume.max_value
