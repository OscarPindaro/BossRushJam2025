extends Button

@export var action = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.button_down.connect(_on_button_pressed)
	self.button_up.connect(_on_button_released)


func _on_button_pressed():
	print("pressed button ", action)
	Input.action_press(action)


func _on_button_released():
	Input.action_release(action)
