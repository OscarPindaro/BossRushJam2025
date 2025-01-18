@tool
@icon("res://asset/bosses/pestone_area.png")
extends Node2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var collision_shape: CollisionShape2D = $InteractionArea/InteractionShape

@export var interaction_radius : float :
	set(value):
		interaction_radius = float(value)
		print("collision type ", collision_shape)
		if collision_shape != null:
			print("aa")
			collision_shape.shape.radius = interaction_radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision_shape == null:
		collision_shape = $InteractionArea/InteractionShape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
