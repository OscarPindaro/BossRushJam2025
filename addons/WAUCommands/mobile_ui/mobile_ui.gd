extends Control

@onready var d_pad: Control = $CanvasLayer/DPad
@onready var ui_button = preload("res://addons/WAUCommands/mobile_ui/mobile_ui_button.tscn")
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var dpad_actions = ["wau_up", "wau_left", "wau_down", "wau_right"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var is_mobile_platform = DisplayServer.is_touchscreen_available()
	if is_mobile_platform:
		self.show_all()
		print("on mobile")
	else:
		self.hide_all()
		print("not on mobile")
	
	# Extract all the custom commands set up
	var custom_commands: Dictionary = {}
	for action in InputMap.get_actions():
		if action.begins_with('wau_'):
			print('Events for action ', action)
			custom_commands[action] = []
			
	# build the DPAD
	var ui_button_size = ui_button.instantiate().size
	var dpad_center = d_pad.size / 2.0
	var radius = min(d_pad.size.x, d_pad.size.y) / 2.0 - max(ui_button_size.x, ui_button_size.y) / 2.0  # margin for button size
	
	var d_pad_buttons_positions = arrange_in_circle(len(dpad_actions), radius, dpad_center)
	
	for i in range(len(dpad_actions)):
		var pos = d_pad_buttons_positions[i]
		var new_button = ui_button.instantiate()
		new_button.action = dpad_actions[i]
		new_button.text = dpad_actions[i]
		d_pad.add_child(new_button)
		new_button.position = pos - new_button.size / 2
		
		custom_commands.erase(dpad_actions[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# evenly distribute objects in a circle
func arrange_in_circle(num_objects: int, radius: float, center=Vector2.ZERO, start_offset=0) -> Array:
	var output = []
	if num_objects == 0:
		return output
		
	var offset = 2.0 * PI / abs(num_objects) # could verify that n is non-zero and
	for i in range(num_objects):
		var pos = radius * Vector2.from_angle(start_offset + i * offset)
		output.push_front(pos + center)
	return output


func show_all():
	self.show()
	canvas_layer.show()
	
func hide_all():
	self.hide()
	canvas_layer.hide()
