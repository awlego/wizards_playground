extends Area2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.ZERO
@export var texture_path: String = "res://assets/images/unknown_texture.png"

signal hit(target: Node)

func _ready() -> void:
	print(texture_path)
	$Sprite.texture = load(texture_path)
	# Center the sprite's offset
	var sprite_size = $Sprite.texture.get_size()
	$Sprite.offset = - sprite_size / 2

	# Center the collision shape
	var collision_shape = $CollisionShape2D.shape
	if collision_shape is RectangleShape2D:
		collision_shape.extents = sprite_size / 2
	elif collision_shape is CapsuleShape2D:
		collision_shape.height = sprite_size.y
		collision_shape.radius = sprite_size.x / 2

	self.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	emit_signal("hit", body)
	queue_free()
