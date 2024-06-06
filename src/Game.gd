extends Node

var enemies = []
var PlayerScript = preload("res://src/player.tscn")
var EnemyScript = preload("res://src/enemy.tscn")
var original_location = Vector2(0, 0)
var drag_offset = Vector2(0, 0)
var snap_spot = null

func _ready():
	create_player()
#	create_enemy()
	pass

func _process(_delta):
	pass


func _unhandled_input(event):
	print("Unhandled input received: ", event)

func _unhandled_gui_input(event):
	print("Unhandled GUI input received: ", event)
		
func _input(event):

	if event.is_action_pressed("_debug Spawn Enemy"):
		create_enemy()
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not Global.hovered_spell_card:
				return
			
			if Global.hovered_spell_card.draggable:
				drag_offset = Global.hovered_spell_card.global_position - event.global_position
				Global.is_dragging = true
				original_location = event.global_position

				update_would_snap()
		else:
			Global.is_dragging = false
			#if Global.hovered_spell_card:
				#snap()

	elif event is InputEventMouseMotion and Global.is_dragging:
		Global.hovered_spell_card.global_position = event.global_position + drag_offset
		
func create_player():
	var player = PlayerScript.instantiate()
	self.add_child(player)

func create_enemy():
	var new_enemy = EnemyScript.instantiate()
	self.add_child(new_enemy)
	enemies.append(new_enemy)

	
func calc_snap_spot():
	if Global.snap_location != null:
		snap_spot = Global.snap_location
	else:
		snap_spot = original_location + drag_offset
	return snap_spot
	
func update_would_snap():
	snap_spot = calc_snap_spot()
	
func snap():
	Global.hovered_spell_card.global_position = calc_snap_spot()
	Global.hovered_spell_card_slot.add_spell(Global.hovered_spell_card)
#	Global.hovered_spell_card_prev_slot.remove_spell(Global.hovered_spell_card)
	# add to new holder
	
	# remove from old holder
	
	# maybe use reparent so I don't duplicate the object?

