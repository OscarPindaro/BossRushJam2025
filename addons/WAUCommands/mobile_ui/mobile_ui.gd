extends Control

@onready var d_pad: Control = $CanvasLayer/DPad
@onready var ui_button = preload("res://addons/WAUCommands/mobile_ui/touch_button.tscn")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var action_container: Control = $CanvasLayer/ActioButtonsArea/ActionButtons


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
		
			
	# build the DPAD
	var ui_button_size = ui_button.instantiate().button_size
	var dpad_center = d_pad.size / 2.0
	var radius = min(d_pad.size.x, d_pad.size.y) / 2.0 - ui_button_size / 2.0  # margin for button size
	
	var d_pad_buttons_positions = arrange_in_circle(len(dpad_actions), radius, dpad_center)
	
	for i in range(len(dpad_actions)):
		var pos = d_pad_buttons_positions[i]
		var new_button = _create_button(dpad_actions[i], d_pad)
		new_button.name = dpad_actions[i]
		new_button.position = pos
		custom_commands.erase(dpad_actions[i])
		
		
	# build actions container with a [actions_grid_size X actions_grid_size] grid
	action_container.columns = actions_grid_size
	for i in range(actions_grid_size * actions_grid_size):
		var control_container = Control.new()
		control_container.name = str(i)
		control_container.custom_minimum_size = Vector2(ui_button_size, ui_button_size)
		action_container.add_child(control_container)

	# position the buttons in the grid according to a specific logic
	var positions = []
	
	if actions_grid_size == 3:
		match len(custom_actions):
			0: positions = []
			1: positions = ["4"]
			2: positions = ["1", "3"]
			3: positions = ["2", "4", "6"]
			4: positions = ["1", "3", "4", "5"]
			5: positions = ["1", "3", "4", "5", "7"]
			_: for i in range(len(custom_actions)):
					positions.append(str(i))
		#positions = get_grid_positions(len(custom_actions), actions_grid_size)
	else:		
		positions = get_grid_positions(len(custom_actions), actions_grid_size)
				
	for i in range(len(custom_actions)):
		var control_container = action_container.get_node(positions[i])
		var action_btn = _create_button(custom_actions[i], control_container)
		action_btn.position = control_container.custom_minimum_size / 2


	#_build_action_buttons(test_actions)
	
		#var action_btn = _create_button(dpad_actions[index], control_container)
		#action_btn.position = control_container.custom_minimum_size / 2


func _create_button(action: String, father: Node) -> Node:
	var btn = ui_button.instantiate()
	btn.action = action
	btn.text_label = action
	btn.button_color = button_color
	btn.pressed_color = button_pressed_color
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


### DA RIVEDERE
func get_grid_positions(count: int, grid_size: int) -> Array:
	var total_cells = grid_size * grid_size
	var mid = grid_size / 2

	if count == 0:
		return []

	if count == 1:
		# Center
		return [str(mid * grid_size + mid)]

	if count == 2:
		# Top-center, middle-left
		return [
			str((mid - 1) * grid_size + mid),
			str(mid * grid_size + (mid - 1))
		]

	if count == 3:
		# Anti-diagonal: top-right, center, bottom-left
		return [
			str((mid - 1) * grid_size + (mid + 1)),
			str(mid * grid_size + mid),
			str((mid + 1) * grid_size + (mid - 1))
		]

	if count == 4:
		# Cross without bottom
		return [
			str((mid - 1) * grid_size + mid),
			str(mid * grid_size + (mid - 1)),
			str(mid * grid_size + mid),
			str(mid * grid_size + (mid + 1))
		]

	if count == 5:
		# Full cross
		return [
			str((mid - 1) * grid_size + mid),
			str(mid * grid_size + (mid - 1)),
			str(mid * grid_size + mid),
			str(mid * grid_size + (mid + 1)),
			str((mid + 1) * grid_size + mid)
		]

	# 6+ items: sequential fill
	var positions = []
	for i in range(min(count, total_cells)):
		positions.append(str(i))
	return positions
