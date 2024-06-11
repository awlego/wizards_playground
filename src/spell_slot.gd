#spell_slot.gd
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
	equipped_spell_card = spell

func remove_spell():
	equipped_spell_card = null

func is_occupied():
	if equipped_spell_card:
		return true
	return false


func _on_spell_casted(spell_slot_body_ref):
	print("Spell casted from slot: ", spell_slot_body_ref.get_parent().slot_position)
	# Handle the spell cast event here
	pass # Replace with function body.
