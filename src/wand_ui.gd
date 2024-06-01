extends Control

var SpellSlotScript = preload("res://src/spell_slot.tscn")

var is_inside_dropable = false
var body_ref
var original_location = Vector2(0, 0)
var drag_offset = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_all_spell_children()
	_create_debug_wand()
	
#	$SpellSlots.size_flags_vertical = SIZE_EXPAND
#	$SpellSlots.size_flags_horizontal= SIZE_EXPAND

	pass
	
func calc_snap_spot():
	var snap_spot
	if Global.snap_location != null:
		snap_spot = Global.snap_location
	else:
		snap_spot = original_location + drag_offset
	return snap_spot
	
func update_would_snap():
	var snap_spot = calc_snap_spot()
	print(snap_spot)
	
func snap():
	$SpellCard.global_position = calc_snap_spot()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if $SpellCard.draggable:
				drag_offset = $SpellCard.global_position - event.global_position
				Global.is_dragging = true
				original_location = event.global_position

				update_would_snap()
		else:
			Global.is_dragging = false
			snap()
				
	elif event is InputEventMouseMotion and Global.is_dragging:
		$SpellCard.global_position = event.global_position + drag_offset

func remove_all_spell_children():
	var children = $SpellSlots.get_children()
	for child in children:
		child.queue_free()

func create_spell_slot():
	var spell_slot = SpellSlotScript.instantiate()
	$SpellSlots.add_child(spell_slot)
	print(spell_slot)
	var shape = spell_slot.get_node("SpellSlotShape")
	print(shape)
	shape.custom_on_area_shape_entered.connect(_on_area_shape_entered)
	shape.custom_on_area_shape_exited.connect(_on_area_shape_exited)

func _create_debug_wand():
	for i in range(5):
		create_spell_slot()

func _on_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(true)

func _on_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(false)
	
func _process(_delta):
	pass
