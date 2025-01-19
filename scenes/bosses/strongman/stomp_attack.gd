@tool
@icon("res://asset/graphic/bosses/pestone_area.png")
extends Node2D
class_name StompAttack

signal player_entered_interaction_area(body: Node2D) 
signal player_exited_interaction_area(body: Node2D) 

@onready var interaction_area: Area2D = $InteractionArea
@onready var collision_shape: CollisionShape2D = $InteractionArea/InteractionShape
@onready var vortex: Sprite2D = $Vortex

@onready var hurt_box: Area2D = $HurtBox
@onready var stomp_sprite: Sprite2D = $StompSprite

@onready var stomp_sound: AudioStreamPlayer2D = $StompSound

@export var interaction_radius : float :
	set(value):
		interaction_radius = float(value)
		if collision_shape != null:
			collision_shape.shape.radius = interaction_radius
		if vortex != null:
			vortex.scale = Vector2((interaction_radius*1.8) / 100, (interaction_radius*1.8) / 100)

@export var vortex_duration: float = 1
@export var vortex_omega: float = 180
@export var modulation_max: float = 0.7
@export var pull_force: float = 50

@export var spiral_frame_duration: int = 50

var player: Player = null

var enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		vortex.modulate.a = 0
		interaction_area.body_entered.connect(on_player_entered_interaction)
		interaction_area.body_exited.connect(on_player_exited_interaction)
		hurt_box.body_entered.connect(on_player_entered_hurt_box)
		hurt_box.body_entered.connect(on_player_exited_hurt_box)
		self.stomp_sprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pull_player():
	if interaction_area.overlaps_body(player):
		#player.pull(self.global_position, self.pull_force)
		player.pull_spiral(self.global_position, spiral_frame_duration)

func damage_player():
	if hurt_box.overlaps_body(player):
		print("damagin player")
		player.take_damage(1.)


func run() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		enabled = true
		self.stomp_sprite.visible = true
		set_collisions(true)
		stomp_sound.play()

func tween_vortex():
	var tween = get_tree().create_tween()

	# Fade to 0.5 alpha
	tween.tween_property(vortex, "modulate:a", modulation_max, vortex_duration / 2)

	# Fade back to 0 alpha
	tween.tween_property(vortex, "modulate:a", 0, vortex_duration / 2)


	# Rotate the sprite continuously during the vortex duration
	var rot_tween = get_tree().create_tween()
	# rot_tween.tween_interval()
	vortex.rotation_degrees = 0
	rot_tween.tween_property(vortex, "rotation_degrees", vortex_omega, vortex_duration)

# func rotate_vortex(t):



func stop() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		enabled = false
		self.stomp_sprite.visible = false
		set_collisions(false)

func set_collisions(value: bool): 
	$HurtBox/CollisionShape2D.disabled = not value
	# $InteractionArea/InteractionShape.disabled = not value

func on_player_entered_interaction(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		print("Player entered in interaction")
		self.player = body as Player
		player_entered_interaction_area.emit(player)


func on_player_exited_interaction(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		player = null
		player_exited_interaction_area.emit(player)

func on_player_entered_hurt_box(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		player = body as Player

func on_player_exited_hurt_box(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		player = body as Player
