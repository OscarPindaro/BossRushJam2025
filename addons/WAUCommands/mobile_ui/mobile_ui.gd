extends Control

@onready var d_pad: Control = $CanvasLayer/DPad
@onready var ui_button = preload("res://addons/WAUCommands/mobile_ui/touch_button.tscn")

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var action_container: Control = $CanvasLayer/ActionButtons

@export var dpad_actions = ["wau_up", "wau_left", "wau_down", "wau_right"]
@export var custom_actions: Array = []
@export var buttons_per_arc: int = 5

@export var button_color: Color = Color.WHITE
@export var button_pressed_color: Color = Color.GRAY

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
	if custom_actions == []:
		for action in InputMap.get_actions():
			if action.begins_with("ui_") or action.begins_with("editor_") or action.begins_with("spatial_editor"):
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
		new_button.position = pos - Vector2(ui_button_size, ui_button_size) / 2
		custom_commands.erase(dpad_actions[i])
		
	# build actions
	var test_actions = []
	for i in range(4):
		var index = i / 4
		test_actions.append(dpad_actions[index])
	_build_action_buttons(test_actions)
	
	#var action_center = action_container.size - Vector2(ui_button_size, ui_button_size)  / 2.0
	#var action_radius = min(action_container.size.x, action_container.size.y) / 2.0 - max(ui_button_size.x, ui_button_size.y) / 2.0
	


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

# evenly distribute objects in a quarter of circle
func arrange_in_quarter(num_objects: int, radius: float, center: Vector2) -> Array:
	var output = []
	if num_objects == 0:
		return output

	if num_objects == 1:
		# Single button on the arc: place at 45° (middle of the quarter)
		var pos = radius * Vector2.from_angle(-PI / 4.0)
		output.append(pos + center)
		return output

	# Spread across a quarter circle 
	var arc_start = - PI
	var arc_end =  - PI * 1.0 / 2.0
	var step = (arc_end - arc_start) / (num_objects - 1)

	for i in range(num_objects):
		var angle = arc_start + i * step
		var pos = radius * Vector2.from_angle(angle)
		output.append({"position": pos + center, "rotation": angle})

	return output

func arrange_in_quarter_ellipse(num_objects: int, container_size: Vector2, center: Vector2, margin: float = 40.0) -> Array:
	var output = []
	if num_objects == 0:
		return output

	var radius_x = container_size.x / 2.0 - margin
	var radius_y = container_size.y / 2.0 - margin

	if num_objects == 1:
		var angle = -PI / 4.0
		var pos = Vector2(radius_x * cos(angle), radius_y * sin(angle))
		output.append({"position": pos + center, "rotation": _ellipse_tangent_angle(angle, radius_x, radius_y)})
		return output

	var arc_start = - PI
	var arc_end =  - PI * 1.0 / 2.0
	var step = (arc_end - arc_start) / (num_objects - 1)

	for i in range(num_objects):
		var angle = arc_start + i * step
		var pos = Vector2(radius_x * cos(angle), radius_y * sin(angle))
		var tangent_angle = _ellipse_tangent_angle(angle, radius_x, radius_y)
		output.append({"position": pos + center, "rotation": tangent_angle})

	return output

func _ellipse_tangent_angle(angle: float, radius_x: float, radius_y: float) -> float:
	# Derivative of the ellipse gives the tangent direction
	var tangent = Vector2(-radius_x * sin(angle), radius_y * cos(angle))
	return tangent.angle()
	

func _build_action_buttons(actions: Array):
	var ui_button_size = ui_button.instantiate().button_size
	var center = action_container.size - Vector2(ui_button_size,ui_button_size) / 2.0
	var positions = arrange_in_quarter_ellipse(actions.size(), action_container.size, center, 0)

	for i in range(actions.size()):
		var btn = _create_button(actions[i], action_container)
		var data = positions[i]
		btn.position = data["position"] 
#
#func _build_action_buttons(actions: Array):
	#var ui_button_size = ui_button.instantiate().size
	#var center = action_container.size - ui_button_size / 2.0
	#var base_radius = max(action_container.size.x, action_container.size.y) - max(ui_button_size.x, ui_button_size.y) / 2.0
#
	#if actions.size() == 1:
		## Single button: centered
		#var btn = _create_button(actions[0], action_container)
		#btn.position = center - btn.size / 2.0
#
	#elif actions.size() <= buttons_per_arc:
		## One quarter-circle arc
		#var positions = arrange_in_quarter(actions.size(), base_radius, center)
		#for i in range(actions.size()):
			#var btn = _create_button(actions[i], action_container)
#
			#btn.pivot_offset = Vector2(btn.size.x / 2.0, btn.size.y)
			#btn.rotation = positions[i]["rotation"] + PI / 2.0  # tangent to the arc
			#
			#var offset = Vector2(0, -btn.size.y).rotated(positions[i]["rotation"] + PI / 2.0)
			#btn.position = positions[i]["position"] - offset - btn.pivot_offset
#
	#else:
		## Two arcs: inner (smaller radius) and outer (larger radius)
		#var outer_count = buttons_per_arc
		#var inner_count = actions.size() - outer_count
		#var outer_radius = base_radius
		#var inner_radius = base_radius * 0.55
#
		#var outer_positions = arrange_in_quarter(outer_count, outer_radius, center)
		#var inner_positions = arrange_in_quarter(inner_count, inner_radius, center)
#
		#for i in range(outer_count):
			#var btn = _create_button(actions[i], action_container)
			#btn.position = outer_positions[i] - btn.size / 2.0
#
		#for i in range(inner_count):
			#var btn = _create_button(actions[outer_count + i], action_container)
			#btn.position = inner_positions[i] - btn.size / 2.0
