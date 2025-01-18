extends CharacterBody2D




#signal hp_changed #emette la presenza del segnale
#signal hp_changed(valore_emesso) #emette un valore preciso

@onready var animations: AnimatedSprite2D = $Animations

# Player attributes
@export var initial_hp: float
@export var SPEED: float


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = 0
	velocity.y = 0
			
	if direction_x != 0 and direction_y == 0:
		velocity.x = direction_x * SPEED
		animations.play('walk')
	elif direction_y != 0 and direction_x == 0:
		velocity.y = direction_y * SPEED
		animations.play('walk')
	elif  direction_y != 0 and direction_x != 0:
		velocity.y = direction_y * SPEED / sqrt(2)
		velocity.x = direction_x * SPEED / sqrt(2)
		animations.play('walk')
	else:
		animations.play('idle')
		
		
		
	move_and_slide()
