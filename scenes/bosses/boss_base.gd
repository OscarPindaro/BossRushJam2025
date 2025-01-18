extends CharacterBody2D
class_name BossBase

@export var hp: float = 100
@export var speed: float = 100 
@export var player: Player 

@onready var animations: AnimatedSprite2D = get_node_or_null("Animations")
@onready var hurtbox: Area2D = get_node_or_null("Hurtbox")

signal player_entered_hurt_box(body: Node2D) 
signal player_exited_hurt_box(body: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func animate(animation_name: String):
	if animations != null:
		animations.play(animation_name)

func idle():
	animate("idle")

func walk_left():
	animate("walk_left")

func walk_right():
	animate("walk_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hurtbox.overlaps_body(player):
		print("culo")
		player.take_damage(1.)
		
func take_damage(damage) -> void:
	hp -= damage
	pass
