extends Node

@export var first_scene: PackedScene

signal level_started
signal level_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_next_scene(first_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_scene(game_scene: PackedScene) -> void:
	var instance = game_scene.instantiate()
	
	instance._next_scene.connect(_on_next_scene)
	
	if instance.is_in_group("level"):
		emit_signal("level_started")
	else:
		emit_signal("level_ended")
	
	#get_tree().change_scene_to(instance)	
	var activeScenes = get_children()
	
	for scene in activeScenes:
		remove_child(scene)  # Remove the child from the parent node
		scene.queue_free() 
	
	add_child(instance)


func _on_settings_switched() -> void:
	get_tree().paused = !get_tree().paused
	
