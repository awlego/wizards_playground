extends Node2D

# Movement speed in pixels per second
var speed = 600

func _ready():

	self.connect("area_entered", Callable(self, "_on_Player_area_entered"))
	position.x = 1000
	position.y = 1000

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
	print("Touched!")
	print(area.name)
	if area.name == "Enemy":
		print("Game Over!")
		# Here you can restart the game, end it, or perform any other action.

func _draw():
	if $CollisionShape2D.shape:  # Check if a shape is set
		var rect = $CollisionShape2D.shape.extents * 2  # Assuming it's a RectangleShape2D
		draw_rect(Rect2(-rect.x/2, -rect.y/2, rect.x, rect.y), Color(0, 1, 0, 1.0))  # Draw in green with 50% opacity
