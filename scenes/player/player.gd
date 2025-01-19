extends CharacterBody2D
class_name Player

signal player_damaged
signal player_dead

@onready var animations: AnimatedSprite2D = $Animations
@onready var audio: AudioStreamPlayer2D = $Sounds


# Player attributes
@export var initial_hp: float
@export var SPEED: float
var moving = false
var external_velocity: Vector2 = Vector2.ZERO

@onready var current_hp: float = initial_hp

func take_damage(dmg_amount: float) -> float:
	current_hp = current_hp - dmg_amount
	emit_signal("player_damaged", dmg_amount)
	if current_hp < 0:
		player_dead.emit()
	return current_hp
	
func pull(position: Vector2, pull_force: float):
	var direction = position - self.global_position
	self.external_velocity = direction * pull_force


func _physics_process(delta: float) -> void:

	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = 0
	velocity.y = 0
			
	if direction_x != 0 and direction_y == 0:
		velocity.x = direction_x * SPEED
		animations.play('walk')
		moving = true
		audio.play_sound("STEP")
	elif direction_y != 0 and direction_x == 0:
		velocity.y = direction_y * SPEED
		animations.play('walk')
		moving = true
		audio.play_sound("STEP")
	elif  direction_y != 0 and direction_x != 0:
		velocity.y = direction_y * SPEED / sqrt(2)
		velocity.x = direction_x * SPEED / sqrt(2)
		animations.play('walk')
		moving = true
		audio.play_sound("STEP")
	else:
		animations.play('idle')
		if moving:
			audio.play_sound("STOP_MOVING")
			moving = false

	velocity = velocity + external_velocity
		
	move_and_slide()
	external_velocity = Vector2.ZERO
