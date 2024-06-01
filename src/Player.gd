#extends Area2D
extends CharacterBody2D

# Movement speed in pixels per second
var speed = 600
var max_health = 10
var current_health = 10
var faction = 1 
var total_bolts_fired = 0
var gravity = 8000


@onready var left_timothy = preload("res://assets/images/pixel_turtle_clean.png")
@onready var right_timothy = preload("res://assets/images/pixel_turtle_clean_right.png")
@onready var health_bar = get_node("../CanvasLayer/ProgressBar")

@onready var momentum = 0
#@onready var velocity: Vector2 = Vector2.ZERO
@export var max_speed: float = 2000.0
@export var damping: float = 20.0  # Damping factor to slow down velocity towards 0


func _ready():
	#TODO this should set a health and then the external healthbar should connect to it.
	health_bar.max_value = max_health
	health_bar.value = current_health

	position.x = 1000
	position.y = 1000
	
	#scale.x = 0.125
	#scale.y = 0.125
	scale = Vector2(0.125, 0.125)
	#$sprite.scale = scale
	#$CollisionShape2D.scale = scale
	print(scale)
	
	collision_layer = 1 << 1  # Layer 2(Player)
	collision_mask = 1 << 2 | 1 << 4 | 1 << 5 # Collides with Layer 5 (Friendly Fire Projectile),  # Collides with Layer 3 (Enemies), # Collides with Layer 4 (Walls)

	
func _input(event):
#	if event.is_action_pressed("Cast Spell"):
#		shoot_blue_bolt()
	if event.is_action_pressed("Cast Secondary Spell"):
		$Wand.cast()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Example movement logic, replace with your own
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		$CollisionShape2D/sprite.flip_h = true
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		$CollisionShape2D/sprite.flip_h = false
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	if input_vector == Vector2.ZERO:
		# Apply damping to gradually reduce velocity to zero
		velocity = apply_damping(velocity, damping, delta)

	# Apply input to velocity
	velocity += input_vector * 10000 * delta  # Adjust acceleration as needed

	# Clip the velocity
	velocity = clip_velocity(velocity, max_speed)
	#position = position + velocity
	move_and_slide()



func clip_velocity(vel: Vector2, max_speed: float) -> Vector2:
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
	return vel

func apply_damping(vel: Vector2, damping: float, delta: float) -> Vector2:
	if vel.length() > 0:
		var damping_factor = 1 - damping * delta
		vel *= max(damping_factor, 0)  # Ensure velocity does not flip direction
	return vel

func take_damage(amount):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	update_health_bar()
	if current_health == 0:
		print("Game Over!")

func update_health_bar():
	health_bar.value = current_health
	


