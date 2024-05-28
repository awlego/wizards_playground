extends Area2D

# Movement speed in pixels per second
var speed = 600
var max_health = 10
var current_health = 10
var faction = 1 

@onready var health_bar = get_node("../CanvasLayer/ProgressBar")
var Fireball = preload("res://src/fireball.tscn")

@onready var bolt_scene = load("res://src/Bolt.tscn")

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health

	position.x = 1000
	position.y = 1000
	
	collision_layer = 1 << 1  # Layer 2 (Player)
	collision_mask = 1 << 2 | 1 << 4 # Collides with Layer 5 (Friendly Fire Projectile),  # Collides with Layer 3 (Enemies)
	
	#self.connect("area_entered", Callable(self, "_on_Player_area_entered"))

func _input(event):
	if event.is_action_pressed("Cast Spell"):
		shoot_blue_bolt()
	if event.is_action_pressed("Cast Secondary Spell"):
		shoot_purple_bolt()

func _process(delta):
	var velocity = Vector2()

	# Input handling for movement
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	# Normalize velocity so diagonal movement isn't faster
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Move the sprite
	position += velocity * delta

#func _on_Player_area_entered(area):
	#if area.name == "Enemy":
		#take_damage(1)

		 #Here you can restart the game, end it, or perform any other action.

func take_damage(amount):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	update_health_bar()
	if current_health == 0:
		print("Game Over!")

func update_health_bar():
	health_bar.value = current_health
	
func cast_spell():
	var fireball = Fireball.instantiate()
	fireball.position = self.position
	self.get_parent().add_child(fireball)

func shoot_bolt(frames_path: String) -> void:
	if frames_path == "":
		print("Error: No frames path provided for bolt.")
		return

	var bolt = bolt_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - self.position).normalized()
	
	bolt.direction = direction
	bolt.rotation = direction.angle()
	bolt.frames_path = frames_path # Set the frames of the bolt
	bolt.position = self.position # Set the starting position to the character's center

	bolt.connect("hit", Callable(self, "_on_bolt_hit"))
	self.get_parent().add_child(bolt)

func _on_bolt_hit(target: Node) -> void:
	# Handle what happens when the bolt hits something
	print("Bolt hit ", target.name)

func shoot_purple_bolt() -> void:
	shoot_bolt("res://assets/frames/purple_bolt_frames.tres")

func shoot_blue_bolt() -> void:
	shoot_bolt("res://assets/frames/blue_bolt_frames.tres")

