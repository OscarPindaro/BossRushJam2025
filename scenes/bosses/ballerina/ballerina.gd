extends "res://scenes/bosses/boss_base.gd"

@export var ziopera = 1
@export var curr_velocity :float
@export var target: CharacterBody2D = null
@export var max_vel :float
@export var speed_exponent :float
var direction = Vector2()
var ramp_up = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = (target.global_position - position).normalized()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ramp_up == 1:
		curr_velocity = curr_velocity ** speed_exponent
		if curr_velocity > max_vel:
			ramp_up = 0
	if ramp_up == 0:
		curr_velocity = curr_velocity ** 0.95
	self.velocity = direction*curr_velocity
	self.move_and_slide()
	pass	


func _on_do_something_timeout() -> void:
	direction = (target.global_position - position).normalized()
	# var distance = target.global_position.distance_to(position)
	# max_vel = distance*5
	curr_velocity = 5
	ramp_up = 1
	pass
