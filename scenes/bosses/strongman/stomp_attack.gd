@tool
@icon("res://asset/bosses/pestone_area.png")
extends Node2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var collision_shape: CollisionShape2D = $InteractionArea/InteractionShape

@onready var hurt_box: Area2D = $HurtBox
@onready var stomp_sprite: Sprite2D = $StompSprite

@onready var stomp_sound: AudioStreamPlayer2D = $StompSound

@export var interaction_radius : float :
	set(value):
		interaction_radius = float(value)
		print("collision type ", collision_shape)
		if collision_shape != null:
			print("aa")
			collision_shape.shape.radius = interaction_radius


var enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		interaction_area.body_entered.connect(on_player_entered_in_interaction)
		interaction_area.body_exited.connect(on_player_exited_in_interaction)
		hurt_box.body_entered.connect(on_player_entered_hurt_box)
		hurt_box.body_entered.connect(on_player_exited_hurt_box)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		enabled = true
		stomp_sprite.visible = true
		set_collisions(true)
		stomp_sound.play()

func stop() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		enabled = false
		stomp_sprite.visible = false
		set_collisions(false)

func set_collisions(value: bool):
	$HurtBox/CollisionShape2D.disabled = not value
	$InteractionArea/InteractionShape.disabled = not value

func on_player_entered_in_interaction(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		var player = body as Player
		# probably i need to give the player the position in their coordinate space
		player.pull(self.position)

func on_player_exited_in_interaction(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		var player = body as Player

func on_player_entered_hurt_box(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		var player = body as Player
		player.take_damage(1.)

func on_player_exited_hurt_box(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		var player = body as Player