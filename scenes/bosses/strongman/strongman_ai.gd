extends Node

@export_group("AI Targets")
@export var boss: BossBase = null
@export var target: Node2D = null :
	set(value):
		target = value

var stomp_timer: Timer 

@export var zio: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if boss == null:
		assert(get_parent() is BossBase, "Wrong type for boss")
		boss = get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target != null:
		move_towards(delta, boss, target)
	


func move_towards(_delta, body_to_move: BossBase, curr_target: Node2D):
	if curr_target != null:
		var direction : Vector2 = (curr_target.global_position - body_to_move.position).normalized()
		body_to_move.velocity = direction*boss.speed
		body_to_move.move_and_slide()
		animate_movement(direction, boss)
	else:
		boss.idle()

func animate_movement(direction: Vector2, boss: BossBase):
	if direction.x > 0:
		boss.walk_right()
	else:
		boss.walk_left()
