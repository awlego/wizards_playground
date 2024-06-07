extends Control

var SpellSlotScript = preload("res://src/spell_slot.tscn")
var is_inside_dropable = false
@onready var spell_slot_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# so I can debug just this scene with some children
	if get_parent() != get_tree().root:
		remove_all_spell_children()
		$SpellCard.queue_free()
		$SpellCard2.queue_free()

	pass

func remove_all_spell_children():
	var children = $SpellSlots.get_children()
	for child in children:
		child.queue_free()

func create_spell_slot():
	var spell_slot = SpellSlotScript.instantiate()
	$SpellSlots.add_child(spell_slot)

	spell_slot.slot_position = spell_slot_count
	spell_slot_count += 1
	
func get_spell_slot_location(slot) -> Vector2:
	assert(slot < spell_slot_count)
	print("get_spell_slot_location(): ", slot)
	return($SpellSlots.get_child(slot).get_global_position())
	
func _process(_delta):
	pass
