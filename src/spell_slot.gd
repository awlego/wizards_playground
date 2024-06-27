#spell_slot.gd
#Godot4
extends Control

var is_current_snap_choice = false
@onready var equipped_spell_card = null
@onready var slot_position: int = 0
@onready var spell_slot_shape = $SpellSlotShape


# Called when the node enters the scene tree for the first time.
func _ready():
	spell_slot_shape.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	$SpellSlotShape/HighlightColorRect.visible = false
	$SpellSlotShape/DebugText.text = str(slot_position)
	  
	Global.connect("spell_casted", _on_spell_casted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.is_dragging:
		spell_slot_shape.visible = true
	else:
		spell_slot_shape.visible = true

func add_spell(spell):
	#if equipped_spell_card:
		#print("calling remove during add_spell")
		#remove_spell()
	equipped_spell_card = spell
	print("Added spell %s to slot %s" % [spell, slot_position])

func remove_spell():
	if equipped_spell_card:
		print("Removed spell %s from slot %s" % [equipped_spell_card, slot_position])
		equipped_spell_card.current_spell_slot_body_ref = null
		equipped_spell_card = null
	else:
		print("Attempted to remove spell from empty slot %s" % slot_position)

func is_occupied():
	if equipped_spell_card:
		return true
	return false


func _on_spell_casted(spell_slot_ref):
	# Handle the spell cast event here
	if spell_slot_ref == self:
		print("Spell casted from slot: ", spell_slot_ref.slot_position)
		$SpellSlotShape/HighlightColorRect.visible = true
	else:
		$SpellSlotShape/HighlightColorRect.visible = false
	pass # Replace with function body.
