extends BossBase

signal player_hit

@export var cerchio_scene: PackedScene
@export var base_velocity :float
@export var max_vel :float
@export var speed_exponent :float
@export var turn_speed = 1
@onready var audio_shoot = $Shoot
@onready var audio_dash = $Dash
@onready var audio_defeat = $Defeat
@onready var audio_hit_received = $Hit_received
@onready var animation_sprites: AnimatedSprite2D = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()
var curr_velocity
var direction = Vector2()
var ramp_up = 0
var idle_direction
var action
var cerchio

func get_random_direction() -> Vector2:
	var random_angle = randf() * TAU # TAU is 2π, representing a full circle
	return Vector2(cos(random_angle), sin(random_angle))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_velocity = base_velocity
	direction = (player.global_position - position).normalized()
	idle_direction = get_random_direction()
	action = "idle"
	animation_sprites.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	match action:
		"idle":
			curr_velocity = base_velocity
			direction = idle_direction
		"charge":
			var player_direction = (player.global_position - position).normalized()
			var current_direction = velocity.normalized()
			direction = current_direction.lerp(player_direction, turn_speed * delta).normalized()
			
			animation_sprites.speed_scale = 1 + (curr_velocity/max_vel) * 5
			if ramp_up == 1:
				curr_velocity = curr_velocity + 20
				if curr_velocity > max_vel:
					ramp_up = 0
			if ramp_up == 0:
				curr_velocity = curr_velocity ** 0.98
				if curr_velocity < base_velocity:
					idle_direction = get_random_direction()
					action = "idle"
					animation_sprites.play("idle")

		"shoot":
			direction = Vector2(0, 0)
			curr_velocity = 0
			if cerchio.despawned == true:
				idle_direction = get_random_direction()
				action = "idle"
				animation_sprites.play("idle")

	self.velocity = direction*curr_velocity
	self.move_and_slide()

func _on_do_something_timeout() -> void:
	var what_to_do = rng.randf_range(0, 1)
	if what_to_do < 0.7:
		direction = (player.global_position - position).normalized()
		curr_velocity = 5
		ramp_up = 1
		self.velocity = direction*curr_velocity
		
		animation_sprites.play("charge")
		audio_dash.play()
		action = "charge"

	else:
		animation_sprites.play("shoot")
		await get_tree().create_timer(0.2).timeout 
		direction = (player.global_position - position).normalized()
		cerchio = cerchio_scene.instantiate()
		add_child(cerchio)
		cerchio.global_position = self.global_position
		cerchio.direction =  direction
		cerchio.player_position = player.global_position
		cerchio.boss_position = self.global_position
		audio_shoot.play()
		action = "shoot"
	
func _on_player_hit():
	emit_signal("player_hitted")
	
