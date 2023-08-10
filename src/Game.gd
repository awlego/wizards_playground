extends Node

var enemies = []

func _ready():
	create_player()
	enemies.append(create_enemy())

func _process(delta):
	if len(enemies) == 0:
		create_enemy()

func _input(event):
	if event.is_action_pressed("_debug Spawn Enemy"):
		create_enemy()
		
func create_player():
	self.add_child($Player)

func create_enemy():
	self.add_child($Enemy)
