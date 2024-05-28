extends ProgressBar

@export var offset: Vector2 = Vector2(-50, 200)  # Offset to position the health bar below the enemy

func _ready():
	self.size_flags_horizontal = SIZE_FILL  # Make sure the ProgressBar fills horizontally
	self.size_flags_vertical = SIZE_SHRINK_CENTER  # Center the ProgressBar vertically
	self.size.x = 100
	self.size.y = 10
	update_position()

func _process(delta):
	update_position()

func update_position():
	#if self.get_parent() != null:
		#var parent_position = self.get_parent().global_position
	self.position = offset

func update_health_bar(health):
	self.value = health
