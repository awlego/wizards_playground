extends Node2D

# Movement speed in pixels per second
var speed = 600
var max_health = 10
var current_health = 10 

@onready var health_bar = get_node("../CanvasLayer/ProgressBar")
var Fireball = preload("res://src/fireball.tscn")

@onready var bolt_scene = load("res://src/Bolt.tscn")

func _ready():
	print(typeof(Fireball))
	
	health_bar.max_value = max_health
	health_bar.value = current_health

	position.x = 1000
	position.y = 1000
	
	self.connect("area_entered", Callable(self, "_on_Player_area_entered"))

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

func _on_Player_area_entered(area):
	if area.name == "Enemy":
		take_damage(1)
		if current_health == 0:
			print("Game Over!")
		# Here you can restart the game, end it, or perform any other action.

func take_damage(amount):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	update_health_bar()

func update_health_bar():
	health_bar.value = current_health
	
func cast_spell():
	var fireball = Fireball.instantiate()
	fireball.position = self.position
	self.get_parent().add_child(fireball)

func shoot_bolt(texture_path: String) -> void:
	var bolt = bolt_scene.instantiate()
	bolt.direction = Vector2.RIGHT # Set the direction of the bolt
	bolt.position = global_position + (Vector2.ZERO)# Set the starting position
	print(global_position, bolt.position)
	bolt.texture_path = texture_path # Set the texture of the bolt
	bolt.connect("hit", Callable(self, "_on_bolt_hit"))
	add_child(bolt)

func _on_bolt_hit(target: Node) -> void:
	# Handle what happens when the bolt hits something
	print("Bolt hit ", target.name)

func shoot_purple_bolt() -> void:
	shoot_bolt("res://assets/images/purple_bolt.png")

func shoot_blue_bolt() -> void:
	shoot_bolt("res://assets/images/blue_bolt.png")
