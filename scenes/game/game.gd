extends BaseScene
@export var win_screen : PackedScene 
@export var lose_screen : PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_win()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _win():
	emit_signal("next_scene",win_screen)

func _lose():
	emit_signal("next_scene",lose_screen)
