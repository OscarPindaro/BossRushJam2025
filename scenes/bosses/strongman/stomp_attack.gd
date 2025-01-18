@tool
@icon("res://asset/graphic/bosses/pestone_area.png")
extends Node2D
class_name StompAttack

signal player_entered_interaction_area(body: Node2D) 
signal player_exited_interaction_area(body: Node2D) 

@onready var interaction_area: Area2D = $InteractionArea
@onready var collision_shape: CollisionShape2D = $InteractionArea/InteractionShape

@onready var hurt_box: Area2D = $HurtBox
@onready var stomp_sprite: Sprite2D = $StompSprite

@onready var stomp_sound: AudioStreamPlayer2D = $StompSound

@export var interaction_radius : float :
	set(value):
		interaction_radius = float(value)
		if collision_shape != null:
			collision_shape.shape.radius = interaction_radius

var player: Player = null

var enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		interaction_area.body_entered.connect(on_player_entered_interaction)
		interaction_area.body_exited.connect(on_player_exited_interaction)
		hurt_box.body_entered.connect(on_player_entered_hurt_box)
		hurt_box.body_entered.connect(on_player_exited_hurt_box)
		self.stomp_sprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		if interaction_area.overlaps_body(player):
			print("azz")
			player.pull(Vector2.UP)
		if hurt_box.overlaps_body(player):
			print("bbb")
			player.take_damage(1.)

func run() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		print("StompArea Enabled")
		enabled = true
		self.stomp_sprite.visible = true
		set_collisions(true)
		stomp_sound.play()

func stop() -> void:
	if not Engine.is_editor_hint():
		# Code to execute in game.
		print("StompArea Disabled")
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
		player = body as Player
		player_entered_interaction_area.emit(player)


func on_player_exited_interaction(body: Node2D):
	if body.is_in_group("Player"):
		# add a cast
		print("Player exited in interaction")
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