extends ButtonWrapper

class_name SceneChangeButton

@export var next_scene: PackedScene

signal on_button_pressed(game_scene: PackedScene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_down() -> void:
	emit_signal("button_pressed", next_scene)
	pass # Replace with function body.
