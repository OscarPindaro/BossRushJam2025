extends Control
signal settings_switched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print_tree()
	#_switch_visibility(false)
	#print(visible)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_settings_switched() -> void:
	print("ziopera")
	get_tree().paused = !get_tree().paused
	_switch_visibility(!visible)
	emit_signal("settings_switched")

func _switch_visibility(visible : bool):
	self.visible = visible
	var children = get_children()
	for child in children:
		child.visible = visible
