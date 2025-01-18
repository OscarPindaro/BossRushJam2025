extends BossBase

# timers
@onready var stomp_cooldown_timer: Timer =  $StompTimer
@onready var stomp_duration_time: Timer = $StompDurationTimer

@onready var stomp_attack: StompAttack = $StompAttack

@export var target: Node2D = null :
	set(value):
		target = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stomp_cooldown_timer.timeout.connect(on_stomp_timer_end)
	stomp_duration_time.timeout.connect(on_stomp_duration_end)
	stomp_attack.player_entered_interaction_area.connect(on_player_in_range)
	stomp_attack.player_exited_interaction_area.connect(on_player_out_of_range)
	# stomp_cooldown_timer.start()

func on_player_in_range(body: Node2D):
	print("Player in range")
	start_stomp_timer()

func on_player_out_of_range(body: Node2D):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target != null:
		move_towards(delta, target)

func start_stomp_timer():
	print("Started Stomp Timer")
	stomp_cooldown_timer.start()
	
func move_towards(_delta, curr_target: Node2D):
	if curr_target != null:
		var direction : Vector2 = (curr_target.global_position - self.global_position).normalized()
		self.velocity = direction*self.speed
		self.move_and_slide()
		animate_movement(direction)
	else:
		self.idle()

func on_stomp_timer_end():
	stomp_attack.run()
	stomp_duration_time.start()

func on_stomp_duration_end():
	stomp_attack.stop()
	stomp_cooldown_timer.start()
	

func animate_movement(direction: Vector2):
	if direction.x > 0:
		self.walk_right()
	else:
		self.walk_left()
