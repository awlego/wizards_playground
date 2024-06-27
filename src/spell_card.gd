#spell_card.gd
#Godot4
extends Node2D

var draggable = false
var initial_position: Vector2
var offset: Vector2
var pending_spell_slot_body_ref
var current_spell_slot_body_ref
var is_inside_dropable
var is_hovered

signal spell_casted

@onready var sprite = $ProjectileSprite
@onready var card_sprite = $CardSprite
@onready var collision_shape = $Area2D/CollisionShape2D 
@onready var spell = null
@onready var bolt_scene = preload("res://src/Bolt.tscn")
@onready var animation_path = "res://assets/frames/blue_bolt_frames.tres"

func _ready():	
	#if get_parent() != get_tree().root:
		#global_position = Vector2(400, 400)
		
	$Area2D.mouse_entered.connect(_on_area_2d_mouse_entered)
	$Area2D.mouse_exited.connect(_on_area_2d_mouse_exited)
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
	# Ensure the sprite has a texture
	if sprite.texture:
		# Get the size of the sprite texture
		var texture_size = sprite.texture.get_size()
		texture_size /= 8

		# Ensure the collision shape is a RectangleShape2D
		if collision_shape.shape is RectangleShape2D:
			var rect_shape = collision_shape.shape as RectangleShape2D
			# Set the extents of the RectangleShape2D to half the texture size
			rect_shape.extents = texture_size / 2
		else:
			print("Error: Collision shape is not a RectangleShape2D")
	else:
		print("Error: Sprite does not have a texture")
	
func add_to_slot(new_spell_slot_body_ref):
	var debug_this_function = false
	var new_spell_slot = new_spell_slot_body_ref.get_parent()
	var tween = get_tree().create_tween()
	
	# Store the spell card that's currently in the new slot (if any)
	var displaced_spell = new_spell_slot.equipped_spell_card
	
	# Store the old slot reference before updating it
	print("current_spell_slot_body_ref: ", current_spell_slot_body_ref)
	var old_slot_body_ref = current_spell_slot_body_ref
	var old_spell_slot = old_slot_body_ref.get_parent() if old_slot_body_ref else null
	
	print("This spell (%s) moving from slot %s to slot %s" % [self, old_spell_slot.slot_position if old_spell_slot else "inventory", new_spell_slot.slot_position])
	if displaced_spell:
		print("Displacing spell (%s) from slot %s" % [displaced_spell, new_spell_slot.slot_position])
	
	# Remove this spell from its current slot if it's in one
	if old_slot_body_ref:
		old_spell_slot.remove_spell()
	
	# If there's a spell in the new slot and it's not this spell
	if displaced_spell and displaced_spell != self:
		print("Swapping!")
		
		# Move the displaced spell to the old slot or initial position
		if old_slot_body_ref:
			tween.tween_property(displaced_spell, "global_position", old_slot_body_ref.global_position, 0.05).set_ease(Tween.EASE_OUT)
			old_spell_slot.add_spell(displaced_spell)
			displaced_spell.current_spell_slot_body_ref = old_slot_body_ref
		else:
			tween.tween_property(displaced_spell, "global_position", initial_position, 0.05).set_ease(Tween.EASE_OUT)
			displaced_spell.current_spell_slot_body_ref = null
	
	# Add this spell to the new slot
	new_spell_slot.add_spell(self)
	
	# Move this spell to the new slot position
	tween.tween_property(self, "global_position", new_spell_slot_body_ref.global_position, 0.05).set_ease(Tween.EASE_OUT)

	# Print debug information
	print("This spell (%s) moved to slot %s" % [self, new_spell_slot.slot_position])
	if displaced_spell:
		
		old_spell_slot.add_spell(displaced_spell)
		
		var displaced_slot = "inventory"
		if displaced_spell.current_spell_slot_body_ref:
			displaced_slot = displaced_spell.current_spell_slot_body_ref.get_parent().slot_position
		print("Displaced spell (%s) moved to slot %s" % [displaced_spell, displaced_slot])
	
	# Update this spell's slot reference
	current_spell_slot_body_ref = new_spell_slot_body_ref
	
	# Call print_equipped_spells on the wand
	var wand = get_tree().get_nodes_in_group("wand")[0]  # Assuming there's only one wand
	wand.print_equipped_spells()
	

func _process_drag_n_drop():
	if Input.is_action_just_released("click"):
		Global.is_dragging = false
	
	if not is_hovered:
		return
	if not draggable:
		return
		
	if Input.is_action_just_pressed("click"):
		initial_position = global_position
		offset = get_global_mouse_position() - global_position
		Global.is_dragging = true
	elif Input.is_action_pressed("click"):
		global_position = get_global_mouse_position() - offset
	elif Input.is_action_just_released("click"):
		Global.is_dragging = false
		var tween = get_tree().create_tween()
		if is_inside_dropable:
			add_to_slot(pending_spell_slot_body_ref)
		else:
			tween.tween_property(self, "global_position", initial_position, 0.05).set_ease(Tween.EASE_OUT)
			
			
func _process(_delta):
	_process_drag_n_drop()
	

func shoot_bolt(frames_path: String) -> void:
	if frames_path == "":
		print("Error: No frames path provided for bolt.")
		return
	
	var wand_tip_location = self.get_parent().get_parent().get_parent().global_position
	var bolt = bolt_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - wand_tip_location).normalized()
	
	bolt.direction = direction
	bolt.rotation = direction.angle()
	bolt.frames_path = frames_path # Set the frames of the bolt
	bolt.position = wand_tip_location # Set the starting position to the wand's center

	self.get_parent().get_parent().add_child(bolt)

func _on_area_2d_mouse_entered():
	if not Global.is_dragging and (Global.hovered_spell_card == null or Global.hovered_spell_card == self):
		#print("Mouse entered: SpellCard")
		Global.hovered_spell_card = self
		draggable = true
		is_hovered = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	#print("Mouse exited: SpellCard")
	#if Global.hovered_spell_card == self:
	Global.hovered_spell_card = null
	draggable = false
	is_hovered = false
	scale = Vector2(1.00, 1.00)

func _on_area_2d_body_entered(body: StaticBody2D):
	#print("SpellCard entered dropable area: ", body.is_in_group('dropable'))
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		pending_spell_slot_body_ref = body

		
func _on_area_2d_body_exited(body: StaticBody2D):
	#print("SpellCard exited dropable area")
	if body == pending_spell_slot_body_ref:
		is_inside_dropable = false
		var spell_slot = pending_spell_slot_body_ref.get_parent()
	if body.is_in_group('dropable'):
		body.modulate = Color(Color.MEDIUM_PURPLE, .7)
		
func shoot_purple_bolt() -> void:
	shoot_bolt("res://assets/frames/purple_bolt_frames.tres")

func shoot_blue_bolt() -> void:
	shoot_bolt("res://assets/frames/blue_bolt_frames.tres")

func cast():
	Global.emit_spell_casted(current_spell_slot_body_ref.get_parent())
	shoot_bolt(animation_path)

