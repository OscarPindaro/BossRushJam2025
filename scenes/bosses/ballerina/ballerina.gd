extends BossBase

@export var ziopera = 1
@export var curr_velocity = 200
@export var target: CharacterBody2D = null
@export var max_vel = 1200
var direction = Vector2()
var ramp_up = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = (target.global_position - position).normalized()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ramp_up == 1:
		curr_velocity = curr_velocity * 1.1
		if curr_velocity > max_vel:
			ramp_up = 0
	if ramp_up == 0:
		curr_velocity = curr_velocity ** 0.95
	#print(curr_velocity)
	self.velocity = direction*curr_velocity
	self.move_and_slide()
	pass	


func _on_do_something_timeout() -> void:
	direction = (target.global_position - position).normalized()
	curr_velocity = 5
	ramp_up = 1
	pass
