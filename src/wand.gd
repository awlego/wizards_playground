extends Node2D

@onready var spell_slots = $Node/SpellSlotContainer/SpellSlots
@onready var cur_spell_index = 0
@onready var recursion_depth = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func get_next_spell():
	var next_spell = spell_slots.get_child(cur_spell_index).equipped_spell_card
	cur_spell_index += 1
	
	if cur_spell_index >= spell_slots.get_child_count():
		cur_spell_index = 0
		
	if not is_instance_valid(next_spell):
		recursion_depth += 1
		if recursion_depth < 26:
			next_spell = get_next_spell()
	
	recursion_depth = 0
	return next_spell
	
func cast() -> void:
	var spell = get_next_spell()
	spell.cast()
	

func print_equipped_spells():
	for spell_slot in spell_slots.get_children():
		var location = spell_slot.slot_position
		var spell = spell_slot.equipped_spell_card
		print("Slot ", location, ": ", spell)
	print()
	
