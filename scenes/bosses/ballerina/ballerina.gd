extends "res://scenes/bosses/boss_base.gd"

@export var ziopera = 1
@export var start_velocity = 200
@export var target: Node2D = null
var velocity = Vector2()
var direction = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = (target.global_position - position).normalized()
	var start_impulse = direction*start_velocity
	if hit == 1:
		start_vel = start_vel * 0.95
		position += velocity.normalized() * start_vel
	if start_vel <= 10:
		start_vel = speed
		hit = 0
		
	pass
