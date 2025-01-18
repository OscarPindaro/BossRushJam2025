extends CharacterBody2D
class_name Player



#signal hp_changed #emette la presenza del segnale
#signal hp_changed(valore_emesso) #emette un valore preciso

@onready var animations: AnimatedSprite2D = $Animations
@onready var audio: AudioStreamPlayer2D = $Sounds


# Player attributes
@export var initial_hp: float
@export var SPEED: float
var moving = false

var current_hp: float = initial_hp


func take_damage(dmg_amount: float) -> float:
	current_hp = current_hp - dmg_amount
	return current_hp
	
func pull(direction: Vector2):
	pass

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
		
		
		
	move_and_slide()
