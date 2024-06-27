#wand.gd
#godot4
extends Node2D

var SpellCard = preload("res://src/spell_card.tscn")
@onready var spell_slot_container = $Node/SpellSlotContainer
@onready var spell_slots = $Node/SpellSlotContainer/SpellSlots
@onready var cur_spell_index = 0
@onready var recursion_depth = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("wand")
	_create_debug_wand()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func wand_refresh():
	# resets the deck to the start state
	#TODO
	pass
	
func get_next_spell():
	# draws a card from the deck and returns it
	var next_spell = spell_slots.get_child(cur_spell_index).equipped_spell_card
	cur_spell_index += 1
	
	if cur_spell_index >= spell_slots.get_child_count():
		wand_refresh()
		cur_spell_index = 0
		
	if not is_instance_valid(next_spell):
		#print("attempting to fetch spell instance ", next_spell)
		recursion_depth += 1
		if recursion_depth < spell_slots.get_child_count():
			next_spell = get_next_spell()
		else:
			print("Didn't find spell before we hit get_next_spell recursion depth (", spell_slots.get_child_count(), ")")
	
	recursion_depth = 0
	return next_spell
	
func cast() -> void:
	var spell = get_next_spell()
	if spell:
		spell.cast()
	print_equipped_spells()
	
func _create_debug_wand():
	for i in range(6):
		spell_slot_container.create_spell_slot()
		
	var purple_bolt_spell_card = SpellCard.instantiate()
	spell_slot_container.add_child(purple_bolt_spell_card)
	purple_bolt_spell_card.animation_path = ("res://assets/frames/purple_bolt_frames.tres")
	var card_sprite = purple_bolt_spell_card.get_node("CardSprite")
	card_sprite.color = Color(255, 0, 255)
	purple_bolt_spell_card.position = spell_slot_container.get_spell_slot_location(3)
	purple_bolt_spell_card.position = Vector2(400, 50)
	#print((purple_bolt_spell_card.global_position))
	
	var blue_bolt_spell_card = SpellCard.instantiate()
	spell_slot_container.add_child(blue_bolt_spell_card)
	blue_bolt_spell_card.animation_path = ("res://assets/frames/blue_bolt_frames.tres")
	card_sprite = blue_bolt_spell_card.get_node("CardSprite")
	card_sprite.color = Color(0, 0, 255)
	blue_bolt_spell_card.global_position = spell_slot_container.get_spell_slot_location(2)
	blue_bolt_spell_card.position = Vector2(200, 50)
	#print((blue_bolt_spell_card.global_position))
	#blue_bolt_spell_card.global_position = Vector2(200, 200)
	
	print()
	for i in range(spell_slot_container.spell_slot_count):
		print(spell_slot_container.get_spell_slot_location(i))
	print()
	
func print_equipped_spells():
	for spell_slot in spell_slots.get_children():
		var location = spell_slot.slot_position
		var spell = spell_slot.equipped_spell_card
		print("Slot ", location, ": ", spell)
	print()
	
