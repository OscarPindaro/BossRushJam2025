extends Control
signal settings_switched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Why visible?")
	visible = false
	_switch_visibility(visible)
	print(visible)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_settings_switched() -> void:
	get_tree().paused = !get_tree().paused
	visible = !visible
	_switch_visibility(visible)
	emit_signal("settings_switched")

func _switch_visibility(visible : bool):
	var children = get_children()
	for child in children:
		child.visible = visible
