extends TouchScreenButton

@export var text_label: String = "":
	set(value):
		text_label = value
		if is_node_ready():
			$Label.text = value

@export var button_size: float = 128.0:
	set(value):
		button_size = value
		if is_node_ready():
			shape.radius = button_size / 2.0

@export var button_color: Color = Color.WHITE:
	set(value):
		button_color = value
		queue_redraw()

@export var pressed_color: Color = Color.GRAY

func _draw():
	var center = Vector2(0,0)
	draw_circle(center, button_size / 2.0, button_color)
	
func _ready():
	$Label.text = text_label
	shape.radius = button_size / 2.0
	pressed.connect(_on_pressed)
	released.connect(_on_released)

func _on_pressed():
	self_modulate = pressed_color

func _on_released():
	self_modulate = Color.WHITE
