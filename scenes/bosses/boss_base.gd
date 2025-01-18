extends CharacterBody2D
class_name BossBase

@export var hp: float
@export var speed: float = 100 

@onready var animations: AnimatedSprite2D = get_node_or_null("Animations")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	pass
	
func on_hit() -> void:
	pass
