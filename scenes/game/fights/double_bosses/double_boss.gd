extends Node2D

signal win
signal lose

@onready var ballerina_healthbar = $BallerinaHealthbar
@onready var strongman_healthbar = $StrongmanHealthbar
@onready var player_healthbar = $PlayerHealthbar
@onready var ballerina_boss = $Ballerina
@onready var strongman_boss = $Strongman
@onready var player = $Player

@export var enter_transition_duration: float = 1

var ballerina_hp
var strongman_hp
var player_hp
@onready var ballerina_dead = false
@onready var strongman_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	strongman_healthbar.value = 100
	ballerina_healthbar.value = 100
	player_healthbar.value = 100
	ballerina_hp = ballerina_boss.initial_hp
	strongman_hp = strongman_boss.initial_hp
	player_hp =  player.initial_hp
	
	ballerina_boss.connect("boss_damaged", _on_ballerina_damaged)
	ballerina_boss.boss_dead.connect(_on_ballerina_dead)
	
	strongman_boss.connect("boss_damaged", _on_strongman_damaged)
	strongman_boss.boss_dead.connect(_on_strongman_dead)
		
	player.connect("player_damaged", _on_player_damaged)	
	player.player_dead.connect(_on_player_dead)
	create_bounce_tween()
	pass # Replace with function body.

func create_bounce_tween():
	var tween = get_tree().create_tween()
		
	# Tween the position
	tween.tween_property(player, "position", $PlayerEnterPosition.position, enter_transition_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(ballerina_boss, "position", $BallerinaEnterPosition.position, enter_transition_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(strongman_boss, "position", $StrongmanEnterPosition.position, enter_transition_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_ballerina_damaged(damage) -> void:
	ballerina_hp -= damage
	ballerina_healthbar.value = 100*(ballerina_hp/ballerina_boss.initial_hp)

func _on_strongman_damaged(damage) -> void:
	strongman_hp -= damage
	strongman_healthbar.value = 100*(	strongman_hp/strongman_boss.initial_hp)
	
func _on_ballerina_dead():
	print("BALLERINA IS DEAD")
	ballerina_dead = true
	ballerina_boss.queue_free()
	if strongman_dead == true:
		emit_signal("win")

func _on_strongman_dead():
	print("STRONGMAN IS DEAD")
	strongman_dead = true
	strongman_boss.queue_free()
	if ballerina_dead == true:
		emit_signal("win")
		


func _on_player_damaged(damage) -> void:
	player_hp -= damage
	player_healthbar.value = 100*(player_hp/player.initial_hp)
	
func _on_player_dead():
	print("PLAYER IS DEAD")
	emit_signal("lose")
