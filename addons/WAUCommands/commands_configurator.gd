@tool
extends Control

@onready var save_button: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/SaveButton
@onready var load_button: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/LoadButton
@onready var save_checkbox: CheckButton = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/SaveOnlyCustomButton
@onready var load_checkbox: CheckButton = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/LoadOnlyCustomButton
@onready var all_settings_textbox: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AllSettingsPath
@onready var custom_settings_textbox: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/CustomSettingsPath
@onready var popup_panel: ConfirmationDialog = $PopupPanel
@onready var local_commands: ItemList = $MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer/LocalCommands
@onready var saved_commands: ItemList = $MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer2/SavedCommands


var all_settings_path = ""
var custom_settings_path = ""

func _ready():
	popup_panel.hide()
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	popup_panel.confirmed.connect(_on_restart_pressed)
	custom_settings_textbox.editing_toggled.connect(_fill_saved_commands_list)
	save_checkbox.pressed.connect(_fill_local_commands_list)
	load_checkbox.pressed.connect(_fill_saved_commands_list)
	
	all_settings_path = all_settings_textbox.text if all_settings_textbox.text != '' else all_settings_textbox.placeholder_text
	custom_settings_path = custom_settings_textbox.text if custom_settings_textbox.text != '' else custom_settings_textbox.placeholder_text
	
	
	## FILL SAVED COMMANDS LIST
	_fill_saved_commands_list()
	
	## ITEM LIST FILL
	_fill_local_commands_list()

# -------------------------
# SAVE
# -------------------------
func _on_save_pressed():
	all_settings_path = all_settings_textbox.text if all_settings_textbox.text != '' else all_settings_textbox.placeholder_text
	custom_settings_path = custom_settings_textbox.text if custom_settings_textbox.text != '' else custom_settings_textbox.placeholder_text
	
	var path = ""
	if save_checkbox.button_pressed:
		path = custom_settings_path
	else:
		path = all_settings_path
	
	var data = CommandsConfig.new()

	var actions = []
	var selected_commands_idxs = local_commands.get_selected_items()
	for idx in selected_commands_idxs:
		actions.append(local_commands.get_item_text(idx))
	
	if len(actions) == 0:
		actions = _extract_actions_names()
	
	for action_name in actions:
		var prop_name = "input/" + action_name
		var action_info = ProjectSettings.get_setting(prop_name)
		# action_info is a Dictionary with "deadzone" and "events" keys
		data.controls[action_name] = action_info["events"]
		
	#var folder_path = path.left(path.rfind("/"))
	var folder_path = path.get_base_dir()
	if folder_path != "" and folder_path != "res://":
		var dir_error = DirAccess.make_dir_recursive_absolute(folder_path)
		if dir_error != OK:
			printerr("Failed to create provided directory!")
			return
	
	# Save the file
	ResourceSaver.save(data, path)
	# Reload the file in the editor
	EditorInterface.get_resource_filesystem().update_file(path)
	# Reload the local commands list
	_fill_saved_commands_list()
	print("Saved to ", path)


func _extract_actions_names() -> Array:
	var actions = []
	for prop in ProjectSettings.get_property_list():
		var prop_name: String = prop["name"]
		if not prop_name.begins_with("input/"):
			continue
			
		var action_name = prop_name.trim_prefix("input/")
		
		if save_checkbox.button_pressed:
			if action_name.begins_with("ui_") or action_name.begins_with("editor_") or action_name.begins_with("spatial_editor"):
				continue
		
		actions.append(action_name)
	
	return actions
# -------------------------
# LOAD
# -------------------------
func load_data_from_selected_file() -> CommandsConfig:
	all_settings_path = all_settings_textbox.text if all_settings_textbox.text != '' else all_settings_textbox.placeholder_text
	custom_settings_path = custom_settings_textbox.text if custom_settings_textbox.text != '' else custom_settings_textbox.placeholder_text
	
	var path = ""
	if load_checkbox.button_pressed:
		path = custom_settings_path
	else:
		path = all_settings_path
		
	if not ResourceLoader.exists(path):
		printerr("No config found")
		return
		
	var data: CommandsConfig = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)

	if not data:
		printerr("Invalid data")
		return
	
	return data
	
	
func _on_load_pressed():
	var data = load_data_from_selected_file()
	
	var selected_actions = []
	var selected_action_idx = saved_commands.get_selected_items()
	for idx in selected_action_idx:
		selected_actions.append(saved_commands.get_item_text(idx))
	
	if data == null:
		return

	_apply_to_project_settings(data, selected_actions)
	print("Loaded and applied")


func _apply_to_project_settings(data: CommandsConfig, selected_actions: Array = []):
	if selected_actions == []:
		selected_actions = data.controls.keys()
		
	for action in data.controls.keys():
		if action in selected_actions:
			print(action)

			var events = data.controls[action]

			# Build ProjectSettings format
			var action_data = {
				"deadzone": 0.5,
				"events": events
			}

			var path = "input/%s" % action
			ProjectSettings.set_setting(path, action_data)

	# Save to project.godot
	var error = ProjectSettings.save()
	if error != OK:
		printerr("Error loading data: ", error)
		return
	else:
		print("project settings saved")
		
	# Refresh InputMap (CRUCIAL)
	InputMap.load_from_project_settings()
	popup_panel.show()
	
	print("ProjectSettings updated")
	
# -------------------------
# BUTTONS
# -------------------------
func _on_restart_pressed():
	popup_panel.hide()
	EditorInterface.restart_editor(true)

# -------------------------
# LISTS
# -------------------------
func _fill_saved_commands_list(toggled=false):
	if toggled == false:
		saved_commands.clear()
		var data = load_data_from_selected_file()
		if data == null:
			return
		for action in data.controls.keys():
			saved_commands.add_item(action)

func _fill_local_commands_list():
	local_commands.clear()
	
	var actions = _extract_actions_names()
	for action in actions:
		local_commands.add_item(action)
