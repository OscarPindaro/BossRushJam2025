extends Node2D

@export var number_of_balls = 5
@export var radius = 100.0
@export var angular_rotation = PI/64
@export var ball_angular_rotation = -PI/64
var rag_ball = preload("res://scenes/balls/rag_ball.tscn")

var active_balls = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var positions = arrange_in_circle(number_of_balls, radius)
	for i in range(number_of_balls):
		active_balls.append(rag_ball.instantiate())
		add_child(active_balls[i])
		active_balls[i].position = positions[i]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.rotate(angular_rotation)
	for ball in active_balls:
		ball.rotate(ball_angular_rotation)
	pass

# evenly distribute objects in a circle
func arrange_in_circle(num_balls: int, radius: float, center=Vector2.ZERO, start_offset=0) -> Array:
	var output = []
	var offset = 2.0 * PI / abs(num_balls) # could verify that n is non-zero and
	for i in range(num_balls):
		var pos = radius * Vector2.from_angle(start_offset + i * offset)
		output.push_front(pos + center)
	return output
	
	

	
	
