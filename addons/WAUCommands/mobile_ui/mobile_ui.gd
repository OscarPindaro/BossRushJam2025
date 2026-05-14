extends Control

@onready var d_pad: Control = $CanvasLayer/DPad
@onready var ui_button = preload("res://addons/WAUCommands/mobile_ui/touch_button.tscn")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var action_container: Control = $CanvasLayer/ActioButtonsArea/ActionButtons
@onready var game_size = Vector2(
	get_viewport().size.x,
	get_viewport().size.y
)

##### EXPORT VARIABLES #####

## Actions to implement in the DPAD. Actions will be deployed clockwhise.
@export var dpad_actions = ["wau_up", "wau_left", "wau_down", "wau_right"]
## Custom actions that will be deployed in the right part of the screen. If empty, the container will be filled with all the available NON DEFAULT actions until the space is filled.
@export var custom_actions: Array = []
## Number of rows and columns in the Actions container. It will accomodate at most 3x3 actions from the custom_actions list or
@export var actions_grid_size: int = 3
## IDLE button color
@export var button_color: Color = Color.WHITE
## Pressed button color
@export var button_pressed_color: Color = Color.GRAY
## Percentage margin to place areas for Dpad and actions
@export_range(0, 1) var button_areas_percentage_size: float = 0.33
## Percentage margin to place areas for Dpad and actions
@export_range(0, 1) var margin_percentage: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if the platform supports touch screen, if yes ENABLE TOUCH UI
	var is_mobile_platform = DisplayServer.is_touchscreen_available()
	if is_mobile_platform:
		self.show_all()
		print("on mobile")
	else:
		self.hide_all()
		print("not on mobile")
		return
	
	# Extract all the custom commands set up
	var custom_commands: Dictionary = {}
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action.begins_with("editor_") or action.begins_with("spatial_editor"):
			if action not in custom_actions:
				continue
		custom_commands[action] = []
	
	####################################
	########## DAPD CREATION ###########
	####################################
	# build the DPAD and fill it with movement actions
	d_pad.size = Vector2(min(game_size.x, game_size.y) * button_areas_percentage_size, min(game_size.x, game_size.y) * button_areas_percentage_size)
	d_pad.global_position.x = game_size.x * margin_percentage
	d_pad.global_position.y = game_size.y - d_pad.size.y - game_size.y * margin_percentage
	
	var ui_button_size = d_pad.size.x / 3
	var dpad_center = d_pad.size / 2.0
	var radius = min(d_pad.size.x, d_pad.size.y) / 2.0 - ui_button_size / 2.0 
	
	var d_pad_buttons_positions = arrange_in_circle(len(dpad_actions), radius, dpad_center)
	
	for i in range(len(dpad_actions)):
		var pos = d_pad_buttons_positions[i]
		var new_button = _create_button(dpad_actions[i], d_pad, ui_button_size)
		new_button.name = dpad_actions[i]
		new_button.position = pos
		custom_commands.erase(dpad_actions[i])
		
	####################################
	###### ACTION AREA CREATION ########
	####################################
	# build actions container with a [actions_grid_size X actions_grid_size] grid
	action_container.size = Vector2(ui_button_size * actions_grid_size, ui_button_size * actions_grid_size)
	action_container.global_position.x = game_size.x - action_container.size.x - game_size.x * margin_percentage
	action_container.global_position.y = game_size.y - action_container.size.y - game_size.y * margin_percentage
	
	action_container.columns = actions_grid_size
	
	for i in range(actions_grid_size):
		for j in range(actions_grid_size):
			var control_container = Control.new()
			control_container.name = str(i) + "," + str(j)
			control_container.custom_minimum_size = Vector2(ui_button_size, ui_button_size)
			action_container.add_child(control_container)

	var positions = []
	
	var offset = actions_grid_size - 3
	
	# Arrange buttons cleanly on the bottom right 3x3 of each action area. If there are more than 5 buttons, start filling the area from position (0,0)
	match len(custom_actions):
		0: positions = []
		1: positions = [(str(1+offset) + "," + str(1+offset))] # ["1,1"]
		2: positions = [(str(0+offset) + "," + str(1+offset)), 
						(str(1+offset) + "," + str(0+offset))] # ["0,1", "1,0"]
		3: positions = [(str(0+offset) + "," + str(2+offset)), 
						(str(1+offset) + "," + str(1+offset)),
						(str(2+offset) + "," + str(0+offset))] # ["0,2", "1,1", "2,0"]
		4: positions = [(str(0+offset) + "," + str(1+offset)), 
						(str(1+offset) + "," + str(0+offset)),
						(str(1+offset) + "," + str(1+offset)),
						(str(1+offset) + "," + str(2+offset))] # ["0,1", "1,0", "1,1", "1,2"]
		5: positions = [(str(0+offset) + "," + str(1+offset)), 
						(str(1+offset) + "," + str(0+offset)),
						(str(1+offset) + "," + str(1+offset)),
						(str(1+offset) + "," + str(2+offset)),
						(str(2+offset) + "," + str(1+offset))] # ["0,1", "1,0", "1,1", "1,2", "2,1"]
		_: for i in range(actions_grid_size):
				for j in range(actions_grid_size):
						positions.append(str(i) + "," + str(j))


				
	for i in range(len(custom_actions)):
		var control_container = action_container.get_node(positions[i])
		var action_btn = _create_button(custom_actions[i], control_container, ui_button_size)
		action_btn.position = control_container.custom_minimum_size / 2


func _create_button(action: String, father: Node, button_size: int) -> Node:
	var btn = ui_button.instantiate()
	btn.action = action
	btn.text_label = action
	btn.button_color = button_color
	btn.pressed_color = button_pressed_color
	btn.button_size = button_size
	father.add_child(btn)

	return btn

func show_all():
	self.show()
	canvas_layer.show()
	
func hide_all():
	self.hide()
	canvas_layer.hide()
		
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
