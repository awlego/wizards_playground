extends Control

var SpellSlotScript = preload("res://src/spell_slot.tscn")
var SpellCard = preload("res://src/spell_card.tscn")
var is_inside_dropable = false
@onready var spell_slot_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	remove_all_spell_children()
	_create_debug_wand()

	pass

func remove_all_spell_children():
	var children = $SpellSlots.get_children()
	for child in children:
		child.queue_free()

func create_spell_slot():
	var spell_slot = SpellSlotScript.instantiate()
	$SpellSlots.add_child(spell_slot)
#	var shape = spell_slot.get_node("SpellSlotShape")
	spell_slot.custom_on_area_shape_entered.connect(_on_area_shape_entered)
	spell_slot.custom_on_area_shape_exited.connect(_on_area_shape_exited)

	spell_slot.slot_position = spell_slot_count
	spell_slot_count += 1

func _create_debug_wand():
	for i in range(5):
		create_spell_slot()
		
	var purple_bolt_spell_card = SpellCard.instantiate()
	add_child(purple_bolt_spell_card)
	purple_bolt_spell_card.animation_path = ("res://assets/frames/purple_bolt_frames.tres")
	var card_sprite = purple_bolt_spell_card.get_node("CardSprite")
	card_sprite.color = Color(255, 0, 255)

	
	var blue_bolt_spell_card = SpellCard.instantiate()
	add_child(blue_bolt_spell_card)
	blue_bolt_spell_card.animation_path = ("res://assets/frames/blue_bolt_frames.tres")
	card_sprite = blue_bolt_spell_card.get_node("CardSprite")
	card_sprite.color = Color(0, 0, 255)


func _on_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(true)
	Global.hovered_spell_card_slot = get_node(platform_rid)

func _on_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index, platform_rid):
	get_node(platform_rid).set_current_snap_choice(false)
	
func _process(_delta):
	pass
