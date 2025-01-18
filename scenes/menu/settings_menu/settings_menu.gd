extends Control
signal settings_switched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_settings_switched() -> void:
	get_tree().paused = !get_tree().paused
	visible = !visible
	emit_signal("settings_switched")
