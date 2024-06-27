extends Node2D

var is_dragging = false
var hovered_spell_card = null

signal spell_casted

func emit_spell_casted(spell_slot_ref):
	emit_signal("spell_casted", spell_slot_ref)
