extends Area2D

var damage = 10
@export var speed: float = 800.0
@export var direction: Vector2 = Vector2.ZERO

@export var frames_path: String = "res://assets/images/unknown_texture.png"
@onready var animated_sprite = $AnimatedSprite2D
@onready var enemy_script = preload("res://src/Enemy.gd")

signal hit(target: Node)

func _ready() -> void:
	var frames = load(frames_path)
	if frames == null:
		print("Error: Could not load frames at path: ", frames_path)
		queue_free()
		return

	animated_sprite.sprite_frames = frames
	animated_sprite.play("default")
	
	# Scale and flip the entire Area2D node
	scale = Vector2(2, 2)
	flip_h()
	## Flip the sprite horizontally to correct orientation
	#animated_sprite.flip_h = true
	#animated_sprite.scale = Vector2(2, 2)

	self.area_entered.connect(_on_area_entered)
	#self.connect("body_entered", Callable(self, "_on_body_entered"))
	
	collision_layer = 1 << 3  # Layer 4 (Projectiles)
	collision_mask = 1 << 2   # Collides with Layer 3 (Enemies)
	
	print("collision_layer: ", collision_layer, ", collision_mask: ", collision_mask)

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Node) -> void:
	print("Bolt hit!")
	if area.is_in_group("enemies"):
		area.take_damage(damage)
	emit_signal("hit", area)
	queue_free()

# Function to flip the node horizontally
func flip_h() -> void:
	var new_scale = scale
	new_scale.x *= -1
	scale = new_scale
