extends Node2D

var draggable = false
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D 

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
	scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	draggable = false
	scale = Vector2(1.00, 1.00)
