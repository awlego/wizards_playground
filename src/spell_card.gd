extends Node2D

var draggable = false
@onready var sprite = $ProjectileSprite
@onready var card_sprite = $CardSprite
@onready var collision_shape = $Area2D/CollisionShape2D 
@onready var spell = null
@onready var bolt_scene = preload("res://src/Bolt.tscn")
@onready var animation_path = "res://assets/frames/blue_bolt_frames.tres"

func _ready():	
	$Area2D.mouse_entered.connect(_on_area_2d_mouse_entered)
	$Area2D.mouse_exited.connect(_on_area_2d_mouse_exited)
	
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

	
func _process(_delta):
	pass

func _on_area_2d_mouse_entered():
	draggable = true
	Global.hovered_spell_card = self
	scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	draggable = false
#	Global.hovered_spell_card = null
	scale = Vector2(1.00, 1.00)

func shoot_bolt(frames_path: String) -> void:
	if frames_path == "":
		print("Error: No frames path provided for bolt.")
		return

	var bolt = bolt_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - self.global_position).normalized()
	
	bolt.direction = direction
	bolt.rotation = direction.angle()
	bolt.frames_path = frames_path # Set the frames of the bolt
	bolt.position = self.global_position # Set the starting position to the wand's center

	self.get_parent().get_parent().add_child(bolt)


func shoot_purple_bolt() -> void:
	shoot_bolt("res://assets/frames/purple_bolt_frames.tres")

func shoot_blue_bolt() -> void:
	shoot_bolt("res://assets/frames/blue_bolt_frames.tres")


func cast():
	shoot_bolt(animation_path)
