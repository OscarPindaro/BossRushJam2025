extends Area2D

signal player_hit

@export var speed = 15
@export var cooldown = 0.2
var direction
var player_position
var distance_from_player
var boss_position
var distance_from_boss

var change_direction = true
var start_cooldown = false
var despawnable = false
var despawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += direction*speed
	distance_from_player = player_position.distance_to(global_position)
	distance_from_boss = boss_position.distance_to(global_position)
	
	if (distance_from_player < 50):
		start_cooldown = true
	if start_cooldown == true:
		cooldown -= delta
	if cooldown < 0 and change_direction == true:
		direction = -direction
		change_direction = false
		despawnable = true
	if despawnable == true and distance_from_boss < 50:
		despawned = true
		hide()
	
func _on_player_hit():
	emit_signal("player_hitted")
