extends Node

var enemies = []
var PlayerScript = preload("res://src/player.tscn")
var EnemyScript = preload("res://src/enemy.tscn")

func _ready():
	create_player()
	create_enemy()

func _process(delta):
	if len(enemies) == 0:
		create_enemy()

func _input(event):
	if event.is_action_pressed("_debug Spawn Enemy"):
		create_enemy()
		
func create_player():
	var player = PlayerScript.instantiate()
	self.add_child(player)

func create_enemy():
	var new_enemy = EnemyScript.instantiate()
	self.add_child(new_enemy)
	enemies.append(new_enemy)
