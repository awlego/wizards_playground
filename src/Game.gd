extends Node

var enemies = []
var PlayerScript = preload("res://src/player.tscn")
var EnemyScript = preload("res://src/enemy.tscn")
var original_location = Vector2(0, 0)
var drag_offset = Vector2(0, 0)
var snap_spot = null
@onready var health_bar = $CanvasLayer/ProgressBar

func _ready():
	create_player()
#	create_enemy()
	pass

func _process(_delta):
	pass


#func _unhandled_input(event):
	#print("Unhandled input received: ", event)
#
#func _unhandled_gui_input(event):
	#print("Unhandled GUI input received: ", event)
		
func _input(event):

	if event.is_action_pressed("_debug Spawn Enemy"):
		create_enemy()
		

func create_player():
	var player = PlayerScript.instantiate()
	self.add_child(player)
	return player

func create_enemy():
	var new_enemy = EnemyScript.instantiate()
	self.add_child(new_enemy)
	enemies.append(new_enemy)

	

