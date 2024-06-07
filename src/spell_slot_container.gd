extends Control

var SpellSlotScript = preload("res://src/spell_slot.tscn")
var is_inside_dropable = false
@onready var spell_slot_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# so I can debug just this scene with some children
	if get_parent() != get_tree().root:
		remove_all_spell_children()
		#remove SpellCard

	pass

func remove_all_spell_children():
	var children = $SpellSlots.get_children()
	for child in children:
		child.queue_free()

func create_spell_slot():
	var spell_slot = SpellSlotScript.instantiate()
	$SpellSlots.add_child(spell_slot)
#
	#spell_slot.custom_on_area_shape_entered.connect(_on_area_shape_entered)
	#spell_slot.custom_on_area_shape_exited.connect(_on_area_shape_exited)

	spell_slot.slot_position = spell_slot_count
	spell_slot_count += 1
	
func get_spell_slot_location(slot) -> Vector2:
	assert(slot < spell_slot_count)
	print("get_spell_slot_location(): ", slot)
	#TODO
	return Vector2(100, 100)
	#return($SpellSlots.get_child(slot).get_snap_location())
	

func _on_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(true)
	Global.hovered_spell_card_slot = get_node(platform_rid)
	print("Global.hovered_spell_card_slot: ", Global.hovered_spell_card_slot)

func _on_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(false)
	
func _process(_delta):
	pass
