extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_scene_dock_level_started() -> void:
	stop()


func _on_scene_dock_level_ended() -> void:
	play()